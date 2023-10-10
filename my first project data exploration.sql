SELECT * from [portfolio project 1]..[covid data death]
where continent is not NULL
order by 3,4

--SELECT * from [portfolio project 1].. [covid data vaccinations]
--order by 3,4

--select the data we are going to be using..

SELECT location, date, total_cases, new_cases, total_deaths, population
from [portfolio project 1]..[covid data death]
order by 1,2

--Looking Total Cases Vs Total Deaths
--shows likehood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as death_percentage
from [portfolio project 1]..[covid data death]
where [location] like '%states%'
order by 1,2

--Looking at The Total Cases vs Population
--Shows what percentage of population got covid

SELECT location, date, population, total_cases,  (total_cases/population)*100  as PercentPopulationInfected
from [portfolio project 1]..[covid data death]
--where [location] like '%india%'
order by 1,2

--Looking Countries with Highest Comparison Rate compared to Population

SELECT location, population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100  as PercentPopulationInfected
from [portfolio project 1]..[covid data death]
--where [location] like '%india%'
group by population,location
order by PercentPopulationInfected DESC

--Showing Countires with Highest Death Count Per Population


SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project 1]..[covid data death]
--where [location] like '%india%'
where continent is not null
group by location
order by TotalDeathCount DESC



--LETS'S BREAK THINGS DOWN BY CONTINENT
--Showing the Continent with Highest Death Per Population

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project 1]..[covid data death]
--where [location] like '%india%'
where continent is not null
group by continent
order by TotalDeathCount DESC

--Global Numbers

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as death_percentage
from [portfolio project 1]..[covid data death]
--where [location] like '%states%'
where continent is not null
--group by date
order by 1,2

--Looking Total Populatin vs Vaccinations
--using CTE

WITH PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated )
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(bigint,vac.new_vaccinations))over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
from [portfolio project 1]..[covid data death] dea 
JOIN [portfolio project 1]..[covid data vaccinations] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not NULL
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from PopvsVac

--TEMP TABLE
Drop TABLE if EXISTS #PercentPeopleVaccinated

CREATE TABLE #PercentPeopleVaccinated
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date datetime,
    population numeric,
    new_vaccinations numeric,
    RollingPeopleVaccinated numeric
)


INSERT INTO #PercentPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(bigint,vac.new_vaccinations))over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
from [portfolio project 1]..[covid data death] dea 
JOIN [portfolio project 1]..[covid data vaccinations] vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not NULL
--order by 2,3
select * ,(RollingPeopleVaccinated/population)*100
from #PercentPeopleVaccinated


--creating view to stored data for later visualizations

create view PercentPeopleVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(bigint,vac.new_vaccinations))over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
from [portfolio project 1]..[covid data death] dea 
JOIN [portfolio project 1]..[covid data vaccinations] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not NULL
--order by 2,3

select * from PercentPeopleVaccinated