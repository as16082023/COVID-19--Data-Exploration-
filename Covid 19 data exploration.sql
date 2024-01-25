
/*Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select * from covid_deaths;


select * from covid_vaccinations;


/* Viewing the data*/
 select *
 from covid_deaths
 where continent <> ''
 order by 3,4;
 
 select *
 from covid_vaccinations
 where continent <> ''
 order by 3,4;
 
 
 /*Total cases vs Total deaths* - India*/
 /*Shows liklihood of dying if you contract covid */
  select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
 from covid_deaths
 where location like '%India%' and continent <> ''
 order by 1,2;
 

/*Total cases vs Population*/
 /*Shows what percentage of population got covid*/
  select location, date, total_cases, population, (total_cases/population)*100 as percent_population_infected
 from covid_deaths
 where location like '%India%'  and continent <> ''
 order by 1,2;
 
 
 /*Countries with Highest infection rate compared to Population*/
 
 select location, population, max(total_cases) as infected, round(max((total_cases/population))*100,2) as percent_population_infected
 from covid_deaths
 where continent <> ''
 group by location, population
 order by percent_population_infected desc;
 
 /*Countries with Highest Death Count per Population*/
 
select location, max(total_deaths) as TotalDeathCount
from covid_deaths
where continent <> ''
group by location
order by TotalDeathCount desc;

/*Let's break things down by continent*/
/*Showing continents with the highest death count per population*/
select continent, max(total_deaths) as TotalDeathCount
from covid_deaths
where continent <> ''
group by continent
order by TotalDeathCount desc;

/*GLOBAL NUMBERS*/
 select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
  sum(new_deaths)/sum(new_cases)*100 as death_percentage
 from covid_deaths
 where  continent <> ''
 group by date
 order by 1,2;

select  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
  sum(new_deaths)/sum(new_cases)*100 as death_percentage
 from covid_deaths
 where  continent <> ''
 order by 1,2;
 
 
/* Total Population vs Vaccinations*/ 
 
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 from covid_deaths dea
    join  covid_vaccinations vac
      on dea.location = vac.location
      and dea.date = vac.date
      where dea.continent <> ''
      order by 2,3;
      
      
/*USE CTE*/
with PopvsVac (Continent, location, Date, population,new_vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 from covid_deaths dea
    join  covid_vaccinations vac
      on dea.location = vac.location
      and dea.date = vac.date
      where dea.continent <> '')
	/*order by 2,3*/
    select *, (RollingPeopleVaccinated/Population)*100
    from popvsvac;


 /*TEMP TABLE*/
    
Create table  Percent_Population_Vaccinated    
 ( Continent varchar(255),
 Location varchar(255),
 Date varchar(20),
 Population varchar(100),
 New_vaccinations varchar(100),
 RollingPeopleVaccinated varchar(100) );

Insert into Percent_Population_Vaccinated (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 from covid_deaths dea
    join  covid_vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent <> '';


;select *,
 (RollingPeopleVaccinated/Population)*100
From Percent_Population_Vaccinated;





