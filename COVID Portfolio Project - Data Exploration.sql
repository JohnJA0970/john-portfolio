/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/



-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From `coviddeaths.coviddeaths`
order by 1,2

-- Percentage of death everyday  in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From `covid-396208.coviddeaths.coviddeaths`
Where location like '%India%'
order by 1,2

-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases, round((total_cases/population)*100,2) as PercentPopulationInfected
From `covid-396208.coviddeaths.coviddeaths`
Where location like '%States%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From `covid-396208.coviddeaths.coviddeaths`
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From `covid-396208.coviddeaths.coviddeaths`
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From `covid-396208.coviddeaths.coviddeaths`
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location) as RollingPeopleVaccinated
From `covid-396208.coviddeaths.coviddeaths` dea
Join `covid-396208.coviddeaths.covidvaccinations` vac
	On dea.location = vac.location
where dea.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location) as RollingPeopleVaccinated
From `covid-396208.coviddeaths.coviddeaths` dea
Join `covid-396208.coviddeaths.covidvaccinations` vac
	On dea.location = vac.location
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100  as rolling_percentage
From PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location) as RollingPeopleVaccinated
From `covid-396208.coviddeaths.coviddeaths` dea
Join `covid-396208.coviddeaths.covidvaccinations` vac
	On dea.location = vac.location
where dea.continent is not null 




