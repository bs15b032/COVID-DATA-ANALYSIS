select * from port..covid
where continent is not null
order by 3, 4


-- looking at Total Cases vs Total Deaths


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage, population from port..covid
Where location like '%India%'
and continent is not null
order by 1,2


--looking at Total case vs Population
--Shows what percentage of population got covid


select location, date, total_cases, (total_cases/population)*100 as PopulationPercentageInfected, population from port..covid
--Where location like '%India%'
where continent is not null
order by 1,2


--what country has highest infection rate compared to Population


select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PopulationPercentageInfected
from port..covid
where continent is not null
group by location, population
order by PopulationPercentageInfected desc


--showing countries with highest Death Count per population

select location, max(cast(total_deaths as int)) as DeathCount
from port..covid
where continent is not null
group by location
order by DeathCount desc


--showing countries with highest Death Count per population

--select continent, max(cast(total_deaths as int)) as DeathCount
--from port..covid
--where continent is not null
--group by continent
--order by DeathCount desc


--Global Numbers


select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from port..covid
where continent is not null
group by date
order by 1,2


--looking at Total population vs Vaccination


Select de.continent, de.location, de.date, de.population, va.new_vaccinations
,SUM(convert(bigint,va.new_vaccinations))OVER(Partition by de.location
Order by de.location, de.date) as RollingPeopleVaccinated
From port..covid de
join port..vaccination va
	On de.location = va.location 
	AND de.date=va.date
where de.continent is not null
order by 2,3


--USE CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(Select de.continent, de.location, de.date, de.population, va.new_vaccinations
,SUM(convert(bigint,va.new_vaccinations))OVER(Partition by de.location
Order by de.location, de.date) as RollingPeopleVaccinated
From port..covid de
join port..vaccination va
	On de.location = va.location 
	AND de.date=va.date
where de.continent is not null)
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100 from PopvsVac

-- TEMP table

DROP TABLE IF EXISTS #PercentagePopulationVaccinated

create table #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentagePopulationVaccinated
Select de.continent, de.location, de.date, de.population, va.new_vaccinations
,SUM(convert(bigint,va.new_vaccinations))OVER(Partition by de.location
Order by de.location, de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From port..covid de
join port..vaccination va
	On de.location = va.location 
	AND de.date=va.date
--where de.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100 
from #PercentagePopulationVaccinated


--creating view to store data for later visualisations


create view PercentagePopulationVaccinated as
Select de.continent, de.location, de.date, de.population, va.new_vaccinations
,SUM(convert(bigint,va.new_vaccinations))OVER(Partition by de.location
Order by de.location, de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From port..covid de
join port..vaccination va
	On de.location = va.location 
	AND de.date=va.date
where de.continent is not null
--order by 2,3


select* 
from PercentagePopulationVaccinated
