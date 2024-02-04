-- SELECT * FROM Covid.coviddeaths;
-- SELECT * FROM Covid.covidvaccinations;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid.coviddeaths_1;

-- Looking at Total cases vs Total Deaths
-- shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM Covid.coviddeaths_1
WHERE location like '%states%';

-- Looking at the Total Cases vs Population
-- Shows what percentage of population got covid

SELECT location, date, total_cases, population, (total_cases/population) * 100 as PercentPopulationInfected
FROM Covid.coviddeaths_1
WHERE location like '%states%';

-- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population) * 100) AS PercentPopulationInfected
FROM Covid.coviddeaths_1
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;

-- Showing the Countries with the Highest Death count per Population

SELECT location, MAX(CAST(total_deaths AS SIGNED)) as TotalDeathCount
FROM Covid.coviddeaths_1
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc;

-- Showing Continents with Highest Death Counts

SELECT continent, MAX(CAST(total_deaths AS SIGNED)) as TotalDeathCount
FROM Covid.coviddeaths_1
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS SIGNED)) AS total_deaths, SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 as DeathPercentage
FROM Covid.coviddeaths_1
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY total_cases;

-- looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Covid.coviddeaths_1 dea
JOIN Covid.covidvaccinations_1 vac
	ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Covid.coviddeaths_1 dea
JOIN Covid.covidvaccinations_1 vac
	ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

CREATE VIEW TotalDeathCount as
SELECT location, MAX(CAST(total_deaths AS SIGNED)) as TotalDeathCount
FROM Covid.coviddeaths_1
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc;

