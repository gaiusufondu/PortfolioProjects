Select *
From PortfolioProject..CovidDeaths
Where Continent is not Null
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

-- Select the Data to be used

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where Continent is not Null
Order by 1,2

-- Looking at Total cases vs total Deaths
-- Shows Likelihood of Dying if you contract Covid in Nigeria
Select location, date, total_cases, total_deaths, (CAST(total_deaths as float)) / (CAST(total_cases as float)) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2

-- Looking at the Total Cases vs Population in Nigeria

Select location, date, population, total_cases, (CAST(total_cases as float)) / (CAST(population as float)) * 100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where Continent is not Null
--Where location like '%Nigeria%'
Order by 1,2

-- Looking at Countries with the highest Infection Rate Compared To Population
Select location, population, MAX(total_cases) as HighestInfectionCount, (CAST(MAX(total_cases) as float)) / (CAST(population as float)) * 100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where Continent is not Null
Group by population, location
Order by PercentagePopulationInfected Desc

-- Showing the Countries wth the Highest Death count per Population
Select Location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is not Null
Group by location
Order by TotalDeathCount Desc

-- LET'S BREAK THINGS DOWN BY CONTINENT
Select continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is not Null
Group by continent
Order by TotalDeathCount Desc

-- Showing the Continents with the highest death per population
Select continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is not Null
Group by continent
Order by TotalDeathCount Desc

-- GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as Int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM
(NULLIF (new_cases, 0))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not Null
--Where location like '%Nigeria%'
Group by date
Order by 1,2


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint))  OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
,(RolligPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
Order by 2,3



-- USE CTE

With PopvsVac (Continent, Location, date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint))  OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RolligPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac 

-- Creating view to store data for later Visualization

Create View PopvsVac as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint))  OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RolligPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	And dea.date = vac.date
Where dea.continent is not null


Select*
From PopvsVac

