

--Checking Total Cases vs Total Deaths 
	select location,date,total_cases,total_deaths,(cast(total_deaths as float)/cast(total_cases as float))*100 as Death_Percentage
	from PortfolioProject..CovidDeaths
	order by 1,2


--Max Death PercenCtage by Country
	with t1 as(select population, location,max(cast(total_cases as float)) as max_cases,max(cast(total_deaths as float)) max_deaths
	from PortfolioProject..CovidDeaths
	where continent is not null
	group by location, population)

	select location, population, 
	max_cases,(cast(max_deaths as float)/population)*100 as max_percentage
	from t1
	order by max_percentage desc

--Total Cases vs Population
	select location,date,total_cases,population,(cast(total_cases as float)/cast(population as float))*100 as Death_Percentage
	from PortfolioProject..CovidDeaths
	where continent is not null
	order by 1,2

--Countries with highest infection rate as compared to population
	select location,population,max(total_cases) as HighestInfectionCount,
	max((cast(total_cases as float)/population))*100 as InfectionPercentage
	from PortfolioProject..CovidDeaths
	where continent is not null
	group by location,population 
	order by InfectionPercentage desc

-- Max Death Count per Country
	select location, max(cast(total_deaths as int)) as MaxDeaths
	from PortfolioProject..CovidDeaths
	where continent is not null
	group by location
	order by MaxDeaths desc

-- Max Death Count per Continent
	select continent, max(cast(total_deaths as int)) as MaxDeaths
	from PortfolioProject..CovidDeaths
	where continent is not null
	group by continent
	order by MaxDeaths desc
--Above query does not show per continent properly because of how data is structured
--For NA it shows only of US and does not include Canada

---This Query shows proper data per continent but also includes locations like
---High Income, Low Income etc

	select location, max(cast(total_deaths as int)) as MaxDeaths
	from PortfolioProject..CovidDeaths
	where continent is null and location in ('World','Europe','North America', 'Asia', 'South America',
	'Africa','Oceania')
	group by location
	order by MaxDeaths desc

--- Across the World

--- New Cases each day across the world by date

	select date, sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths,
	case when sum(cast(new_cases as int)) = 0 then 0 else
	(sum(cast(new_deaths as int))/sum(new_cases))*100 end as DeathsperNewCase
	from PortfolioProject..CovidDeaths
	where continent is not null
	group by date
	order by 1,2

-- Total New Cases per Deaths across the world in total
	select sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths,
	case when sum(cast(new_cases as int)) = 0 then 0 else
	(sum(cast(new_deaths as int))/sum(new_cases))*100 end as DeathsperNewCase
	from PortfolioProject..CovidDeaths
	where continent is not null
	order by 1,2

--- Total Population vs Vaccinations
--- Common Table Expression 

	with PopulationvsVaccination (continent, location, date, population, new_vaccinations, cumulative_vaccinations) as (
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as Cumulative_Vaccinations
	from
	PortfolioProject..CovidVaccinations vac
	join PortfolioProject..CovidDeaths dea
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null 
	--order by 1,2,3
	)

	select *, (cumulative_vaccinations/population)*100 as PercentVaccinated from
	PopulationvsVaccination



--- Using a temp table
	DROP Table if exists #PercentPopulationVaccinated
	CREATE Table #PercentPopulationVaccinated
	(
	Continent nvarchar(255),
	location nvarchar(255),
	date datetime, 
	population numeric,
	new_vaccinations numeric,
	cumulative_vaccinations numeric
	)

	insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as Cumulative_Vaccinations
	from
	PortfolioProject..CovidVaccinations vac
	join PortfolioProject..CovidDeaths dea
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null 
	--order by 1,2,3

	select *, (cumulative_vaccinations/population)*100 as PercentVaccinated from
	#PercentPopulationVaccinated


--- Creating a View
CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as Cumulative_Vaccinations
	from
	PortfolioProject..CovidVaccinations vac
	join PortfolioProject..CovidDeaths dea
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null 
	---order by 1,2,3

select * from PercentPopulationVaccinated