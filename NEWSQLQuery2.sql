--select*
--from portfolioproject..['Covid Vaccinations$']
--order by 3,4

--select*
--from portfolioproject..['Covid Deaths$']
--order by 3,4

--select location,SUM(total_cases) as total_cases ,sum(new_cases) as new_cases ,sum(total_deaths) as total_deaths
--from portfolioproject..['Covid Deaths$']
--Group by location
--order by 1,2

--select location, date, total_cases , new_cases , total_deaths , (total_deaths/total_cases)*100 as prcdeath
select*
from portfolioproject..['Covid Deaths$']
WHERE total_cases>0 and location like '%Morocco%'
--where location like '%Asia%'
order by 1,2

Select location , MAX(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..['Covid Deaths$']
where continent is not null
Group by location
order by totaldeathcount desc

	Select continent , MAX(total_deaths) as totaldeathcount
	from portfolioproject..['Covid Deaths$']
	where continent is not null
	Group by continent
	order by totaldeathcount desc

select  sum (new_cases)as tutalcases, sum(new_deaths) as tutaldeaths ,(sum(new_deaths) / sum(new_cases) ) * 100 as Deathperc
from portfolioproject..['Covid Deaths$']
WHERE location like '%Morocco%'and continent is not null and new_cases>0
--where location like '%Asia%'
--where continent is not null
--group by date
order by 1,2


With popvsvac(continent,location,date, population,new_vaccinations,cumulativevacs)
as
(
select dea.continent, dea.location , dea.date , vac.population , vac.new_vaccinations , SUM(convert(bigint,isnull(vac.new_vaccinations,0)))
OVER (partition by dea.location order by dea.location , dea.date)as cumulativevacs
from portfolioproject..['Covid Deaths$'] dea
join portfolioproject..['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Morocco%'
--order by 2,3
)
select*,(cumulativevacs/population)*100
from popvsvac
WHERE location like '%Morocco%'

--Create a view

CREATE VIEW popvsvacMorocco as
select dea.continent, dea.location , dea.date , vac.population , vac.new_vaccinations , SUM(convert(bigint,isnull(vac.new_vaccinations,0)))
OVER (partition by dea.location order by dea.location , dea.date)as cumulativevacs
from portfolioproject..['Covid Deaths$'] dea
join portfolioproject..['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Morocco%'
--order by 2,3

CREATE VIEW Moroccocases as
select  sum (new_cases)as tutalcases, sum(new_deaths) as tutaldeaths ,(sum(new_deaths) / sum(new_cases) ) * 100 as Deathperc
from portfolioproject..['Covid Deaths$']
WHERE location like '%Morocco%'and continent is not null and new_cases>0
