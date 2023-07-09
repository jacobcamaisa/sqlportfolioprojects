-- SELECT * FROM `portfolio-project-1-391821.coviddata.covidvax`
-- ORDER BY 3,4;

SELECT * FROM `portfolio-project-1-391821.coviddata.coviddeaths`
WHERE continent is not null
ORDER BY 3,4;

-- Select data being used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `portfolio-project-1-391821.coviddata.coviddeaths`
ORDER by 1, 2;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract COVID in the U.S
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM `portfolio-project-1-391821.coviddata.coviddeaths`
WHERE location = 'United States'
ORDER by 1, 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population contracted COVID in the U.S
SELECT location, date, population, total_cases, (total_cases/population)*100 as infection_rate
FROM `portfolio-project-1-391821.coviddata.coviddeaths`
WHERE location = 'United States'
ORDER by 1, 2;

-- Looking at Countries with Highest Infection Rate compared to population
SELECT location, population, MAX(total_cases) as HighestInfectionRate, MAX(total_cases/population)*100 as infection_rate
FROM `portfolio-project-1-391821.coviddata.coviddeaths`
GROUP BY location, population
ORDER by infection_rate desc;

-- Showing countries with Highest Death Count per population
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM `portfolio-project-1-391821.coviddata.coviddeaths`
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;

-- LETS BREAK THINGS DOWN BY CONTINENT

-- Showing continents with highest death count per population
SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM `portfolio-project-1-391821.coviddata.coviddeaths`
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;


-- GLOBAL NUMBERS
SELECT date, SUM(total_cases) as total_cases, SUM(total_deaths) as total_deaths, SUM(total_deaths)/SUM(total_cases)*100 as DeathPercentage
FROM `portfolio-project-1-391821.coviddata.coviddeaths`
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2;


-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM `portfolio-project-1-391821.coviddata.coviddeaths` as dea
JOIN `portfolio-project-1-391821.coviddata.covidvax` as vac
  ON dea.location = vac.location
  and dea.date = vac.date
WHERE dea.continent is not null
ORDER by 2, 3;

-- USE CTE

WITH PopvsVac AS (
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
  FROM
    `portfolio-project-1-391821.coviddata.coviddeaths` AS dea
  JOIN
    `portfolio-project-1-391821.coviddata.covidvax` AS vac
  ON
    dea.location = vac.location
    AND dea.date = vac.date
  WHERE
    dea.continent IS NOT NULL
  ORDER BY
    2, 3
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;

-- Creating View to store data for later visualizations
CREATE OR REPLACE VIEW `portfolio-project-1-391821.coviddata.PercentPopulationVaccinated` AS
SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM
  `portfolio-project-1-391821.coviddata.coviddeaths` AS dea
JOIN
  `portfolio-project-1-391821.coviddata.covidvax` AS vac
ON
  dea.location = vac.location
  AND dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
ORDER BY
  2, 3;