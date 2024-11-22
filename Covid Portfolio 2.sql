Select *
from PortFolioProject.. CovidDeaths
where continent is not null
order by 3,4


--Select *
--from PortFolioProject.. CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from PortFolioProject.. CovidDeaths
where continent is not null
order by 1,2


Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortFolioProject.. CovidDeaths
Where location like '%Nigeria%'
and continent is not null
order by 1,2


Select Location, date, population, total_cases, (total_cases/population)*100 as Population
from PortFolioProject.. CovidDeaths
Where location like '%Nigeria%'
and continent is not null
order by 1,2


Select Location, population, max(total_cases) as HighestInfection, max(total_cases/population)*100 as PercentPopulationInfected
from PortFolioProject.. CovidDeaths
--Where location like '%Nigeria%'
group by location, population
order by PercentPopulationInfected Desc


Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortFolioProject.. CovidDeaths
--Where location like '%Nigeria%'
where continent is not null
group by location
order by TotalDeathCount Desc


Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortFolioProject.. CovidDeaths
--Where location like '%Nigeria%'
where continent is not null
group by continent
order by TotalDeathCount Desc


Select sum(new_cases) as GlobalNew, SUM(cast(new_deaths as int)) as TotalDeath, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortFolioProject.. CovidDeaths
--Where location like '%Nigeria%'
where continent is not null
--group by date
order by 1,2



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortFolioProject.. CovidDeaths dea
Join PortFolioProject.. CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Using CTE
with PopVsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortFolioProject.. CovidDeaths dea
Join PortFolioProject.. CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac




--Using Temp Table
drop table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortFolioProject.. CovidDeaths dea
Join PortFolioProject.. CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later

Use PortFolioProject
Go
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
From PortFolioProject.. CovidDeaths dea
Join PortFolioProject.. CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated