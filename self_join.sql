-- SELF JOIN

--How many stops are in the database. 
SELECT COUNT(name)
FROM stops;
--Find the id value for the stop 'Craiglockhart' 
SELECT id
FROM stops
WHERE name = 'Craiglockhart';
--Give the id and the name for the stops on the '4' 'LRT' service. 
SELECT id, name
FROM stops JOIN route
ON (stops.id=route.stop)
WHERE route.num = '4' AND route.company = 'LRT';
--The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). 
----Run the query and notice the two services that link these stops have a count of 2. 
----Add a HAVING clause to restrict the output to these two routes. 
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

--Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, 
----without changing routes. 
----Change the query so that it shows the services from Craiglockhart to London Road. 
SELECT a.company, a.num, a.stop, b.stop AS b_stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149;
--The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. 
----Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
----If you are tired of these places try 'Fairmilehead' against 'Tollcross' 
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops AS stopa ON (a.stop=stopa.id)
  JOIN stops AS stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road';
--Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') 
SELECT a.company, a.num 
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 AND b.stop = 137
GROUP BY a.company, a.num;
--Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' 
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops AS stopa ON (a.stop=stopa.id)
  JOIN stops AS stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='Tollcross';
--Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
----including 'Craiglockhart' itself, offered by the LRT company. 
----Include the company and bus no. of the relevant services. 
SELECT stopb.name, a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops AS stopa ON (a.stop=stopa.id)
  JOIN stops AS stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND a.company='LRT';
--Find the routes involving two buses that can go from Craiglockhart to Lochend.
--Show the bus no. and company for the first bus, the name of the stop for the transfer,
----and the bus no. and company for the second bus. 


SELECT tripStart.FirstBus, tripStart.FirstBusCompany, tripStart.transfer, tripEnd.SecondBus, tripEnd.SecondBusCompany
FROM (
SELECT DISTINCT routeA.num AS 'FirstBus', routeA.company AS 'FirstBusCompany', stopB.name AS 'transfer'
FROM route AS routeA JOIN route AS routeB
ON (routeA.num = routeB.num AND routeA.company = routeB.company)
JOIN stops AS stopA 
ON (routeA.stop=stopA.id)
JOIN stops AS stopB 
ON (routeB.stop=stopB.id)
WHERE stopA.name = 'Craiglockhart'
) AS tripStart
JOIN (
SELECT DISTINCT routeC.num AS 'SecondBus', routeC.company AS 'SecondBusCompany', stopC.name AS 'departure'
FROM route AS routeC JOIN route AS routeD
ON (routeC.num = routeD.num AND routeC.company = routeD.company)
JOIN stops AS stopC
ON (routeC.stop=stopC.id)
JOIN stops AS stopD 
ON (routeD.stop=stopD.id)
WHERE stopD.name = 'Lochend'
) AS tripEnd
ON tripStart.transfer=tripEnd.departure
ORDER BY tripStart.FirstBus, tripStart.transfer, tripEnd.SecondBus;