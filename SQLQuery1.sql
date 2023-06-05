select *
from PortfolioProject..CovidDeaths$
order by 3,4

select *
from PortfolioProject..CovidVaccination$
order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths$
order by 1,2

--select location, date,total_cases,new_cases,total_deaths,population
--from CovidVaccination$
--order by 1,2

select  continent,location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as Percentagerate 
from CovidDeaths$
where location like '%states%'
order by 1,2

select  continent,location,date,total_cases,population, (total_cases/population)*100 as Percentagerate 
from CovidDeaths$
where location like '%states%'
order by 1,2


select  continent,location,date,total_cases,population  
from CovidDeaths$ 
order by total_cases desc


select  location,max(total_cases)as highestcase,population, max(total_cases/population)*100 as Percentagehighestrate
from CovidDeaths$
--where location like '%states%'
group by location,population
order by Percentagehighestrate desc

select  location,max(total_deaths)as Deathcounts
from CovidDeaths$
where continent is not null
group by location,population
order by Deathcounts desc

select  continent,max(total_deaths)as Deathcounts
from CovidDeaths$
where continent is not null
group by continent
order by Deathcounts desc


select  continent, population, max(total_deaths/population)as HighestContinentcount
from CovidDeaths$
where continent is not null
group by continent
order by HighestContinentcount desc

select date,sum(new_cases) as TotalCases,sum (cast(new_deaths as int)) as TotalDeaths ,sum(cast(new_deaths as int))/sum(New_cases) *100 as DeathsRate-- (total_deaths/total_cases)*100 as Percentagerate 
from CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2


select date, sum(new_cases) as TotalCases,sum (cast(new_deaths as int)) TotalDeaths ,sum (cast(new_deaths as int))/sum(new_cases) *100 as DeathsRate-- (total_deaths/total_cases)*100 as Percentagerate 
from CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2




select sum(new_cases) as TotalCases,sum (cast(new_deaths as int)) TotalDeaths ,sum (cast(new_deaths as int))/sum(new_cases) *100 as DeathsRate-- (total_deaths/total_cases)*100 as Percentagerate 
from CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2




select *
from PortfolioProject..CovidVaccination$

select *
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccination$ vac
on dea.location=vac.location
and dea.date=vac.date

select dea.continent,dea.location,dea.date,dea.population,
 vac.new_vaccinations,sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date,dea.location) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccination$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

with PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,
 vac.new_vaccinations,sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date,dea.location) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccination$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/population)*100
from PopvsVac

drop table if exists #PercentPopulationVaccinated

create table #PercentPopulationVaccinated(
continent nvarchar(255),
location varchar(255),
date date,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)


insert into  #PercentPopulationVaccinated 
select dea.continent,dea.location,dea.date,dea.population,
 vac.new_vaccinations,sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date,dea.location) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccination$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated/population)*100 as VaccinatedPopulationRate
from #PercentPopulationVaccinated 

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,
 vac.new_vaccinations,sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date,dea.location) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccination$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3





