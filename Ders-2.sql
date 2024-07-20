--STRING FONKSÝYONLARI
Select LTRIM('        Yetenek Baþakþehir')
Select RTRIM('Yetenek Baþakþehir       ')
Select UPPER('Yetenek Baþakþehir')
Select LOWER('YETENEK BAÞAKÞEHÝR')

Select LEFT('Yetenek Baþakþehir',4)
Select RIGHT('Yetenek Baþakþehir',4)
Select SUBSTRING('Yetenek Baþakþehir',2,5)

Select CustomerID,CompanyName,SUBSTRING(CompanyName,1,4) Kod from Customers

Select REVERSE('Yetenek Baþakþehir')
Select REPLACE('Yetenek Baþakþehir','Yetenek','Kariyer')
Select REPLACE('Yetenek Baþakþehir',' ','')

--MATH FONKSÝYONLARI
Select COS(50)
Select TAN(50)
Select ABS(-79)
Select SQRT(49)
Select POWER(2,6)

Select MIN(UnitPrice)
from Products

Select MAX(UnitPrice)
from Products

Select AVG(UnitPrice)
from Products

Select SUM(UnitsInStock)
from Products

select * from Products

--DATETIME FONKSIYONLARI
Select GETDATE()
Select YEAR(GETDATE())
Select MONTH(GETDATE())
Select DAY(GETDATE())

Select DATENAME(DW,'06.24.2024') --dayofweek
Select DATENAME(M,'06.24.2024') --month
Select DATENAME(D,'06.24.2024') --day

Select DATEPART(HOUR,GETDATE()) AS SAAT
Select DATEPART(MINUTE,GETDATE()) AS DAKÝKA

Select FORMAT(GETDATE(),'HH:mm:ss')

Select DATEDIFF(Year,'06.24.1985',GetDate())
Select DATEDIFF(Month,'06.24.1985',GetDate())
Select DATEDIFF(Day,'06.24.1985',GetDate())

Select DATEADD(DAY,15,GETDATE())
Select DATEADD(MINUTE,-35,GETDATE())

--15 hafta sonra bugün yýlýn kaçýncý günüdür?
Select DATEPART(DAYOFYEAR,DATEADD(WEEK,15,GETDATE()))
Select DATEADD(WEEK,15,GETDATE())

--Çalýþanlar için n.davolio@istanbulegitimakademi.com formatýnda email adresleri oluþturulacaktýr. Ad Soyad ve Email Adresi þeklinde listeleyiniz.

Select FirstName+' '+LastName AdSoyad,
LOWER(LEFT(FirstName,1)+'.'+LastName+'@istanbulegitimakademi.com') as Email
from Employees

--Çalýþanlarýn Ad Soyad ve Yaþlarýný listeleyiniz.
Select 
FirstName,
LastName,
DATEDIFF(Year,BirthDate,getdate()) Yas
from Employees

--Ortalama fiyattan pahalý olan ürünler hangileridir.
Select *
from Products 
where UnitPrice>(Select Avg(UnitPrice) from Products)

--SQL AGGREGATE FUNCTIONS (Toplam Fonksiyonlarý)
--AVG, MIN, MAX, SUM, COUNT

--COUNT
--Tablolarda bulunan kayýt sayýsýný saymak için kullanýlan fonksiyondur.

--Toplam kaç adet sipariþimiz bulunmaktadýr. 
Select COUNT(*)
from Orders

--Toplam kaç adet ürünüm bulunmaktadýr.
Select Count(*) UrunSayisi from Products

Select Count(OrderID)
from Orders --830 satýr kayýt geldi.

--Null olmayan alanlarý sayar.
select Count(ShipRegion) from Orders  --323 satýr kayýt geldi.

select Count(*) from Orders where ShipRegion is null	

--Herhangi bir sutunda bulunan benzersiz kayýtlarý saymak için:
--830 adet sipariþ toplam 21 farklý ülkeye göndelirecektir.
Select Count(Distinct ShipCountry) from Orders

--5 numaralý çalýþanýmýz kaç adet sipariþte görev almýþtýr.
Select Count(*)
from Orders
where EmployeeID=5

--2 numaralý kategoriye ait olan toplam kaç adet ürün vardýr.

Select Count(*)
from Products
where CategoryID=2

--Tüm kategorilerimize ait kaç adet ürün bulunmaktadýr?
Select CategoryID,Count(*) UrunAdedi
from Products
group by CategoryID

select * from Products order by CategoryID

--Tüm üreticilerimize ait toplam kaç adet ürünümüz bulunmaktadýr.
Select SupplierID,Count(*) UrunAdedi
from Products
group by SupplierID

--Tüm üreticilerimize ait stoklarýmýzda toplam kaç adet ürünümüz bulunmaktadýr.
Select SupplierID,Sum(UnitsInStock) UrunStokAdedi
from Products
group by SupplierID

--ID'si FRANK olan müþterimize ait kaç adet sipariþ vardýr?

select CustomerID,Count(*) [Sipariþ Sayýsý]
from Orders
where CustomerID='FRANK'
group by CustomerID

select * from Products

--10248 numaralý sipariþimizin içerisinde toplam kaç farklý ürün alýnmýþtýr?
Select OrderID,Count(ProductID)
from [Order Details]
where OrderID=10248
group by OrderID

--10248 numaralý sipariþimizin toplam tutarý nedir?
Select OrderID,ROUND(SUM((UnitPrice*Quantity)*(1-Discount)),2) ToplamTutar
from [Order Details]
where OrderID=10250
group by OrderID

select * from [Order Details]

--Kargo þirketlerinin toplam kaç adet gönderisi vardýr.

select EmployeeID,Count(*) from Orders
group by EmployeeID

--HAVING
--Gruplama yaptýktan sonra elde edilen liste üzerinde herhangi bir kriter (filtre) uygulamak istersek having kullanýlýr.
--Where gruplamadan önce çalýþýr ve filtreleme yapar.
--Having gruplanmýþ datayý filtreler.

--Tüm sipariþlerimiz içerisinde fatura toplamý 10.000$'ýn üzerinde olan sipariþler hangileridir?

Select OrderID,ROUND(SUM((UnitPrice*Quantity)*(1-Discount)),2) ToplamTutar
from [Order Details]
GROUP BY OrderID
HAVING ROUND(SUM((UnitPrice*Quantity)*(1-Discount)),2)>10000

--20.000 $ dan fazla ödeme yapýlan kargo sirketleri hangileridir.

Select ShipVia,Sum(Freight) [Toplam Kargo Ücreti]
from Orders
group by ShipVia
Having Sum(Freight) > 20000

--SQL JOIN
/*
Join ile sql üzerinde birden fazla tabloyu birbirine baðlayabiliriz. Bunun için INNER JOIN ve ON ifadeleri kullanýlýr.

Tablolar genelde PRIMARY KEY  ve FOREIGN KEY üzerinden baðlanýr. Ancak gerektiðinde herhangi bir alan da bu iþlem için kullanýlabilir. Bunun için bu alanlarýn veri tipleri ayný olmalýdýr.

INNER JOIN, OUTER JOIN (left, right), CROSS, UNION
*/

--Ürünlerin isimlerini ve kategori isimlerini listeleyiniz.
select ProductName,CategoryName
from Products
INNER JOIN Categories
ON Categories.CategoryID=Products.CategoryID

--Tablolara etiket tanýmlayarak daha kýsa yazabiliriz.
select ProductName,CategoryName
from Products p
INNER JOIN Categories c
ON c.CategoryID=p.CategoryID

--Tabloda CategoryID isimli 2 farklý sutun olduðundan p.CategoryID þeklinde belirtildi.
select p.CategoryID,ProductName,CategoryName
from Products p
INNER JOIN Categories c
ON c.CategoryID=p.CategoryID

--Çalýþanlarýn yapmýþ olduklarý sipariþ adetlerini, Çalýþan Adý Soyadý, Sipariþ Adedi þeklinde listeleyiniz.
Select FirstName+' '+LastName [Ad Soyad],Count(*) [Sipariþ Adedi]
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID
group by FirstName+' '+LastName

--TOFU isimli ürünün alýndýðý tüm sipariþ numaralarýný listeleyiniz.
Select OrderID
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
where ProductName='Tofu'

--Tüm ürünlerimizi Ürün Adý, Kategori Adý ve Tedarikçi Adý þeklinde listeleyiniz.
Select ProductName,CategoryName,CompanyName from 
Products p
inner join Categories c
on p.CategoryID=c.CategoryID
inner join Suppliers s
on s.SupplierID=p.SupplierID

--Federal Shipping ile tanýþmýþ, Nancy üzerine kayýtlý olan sipariþleri Çalýþan Adý Soyadý, Siparis No, Siparis Tarihi ve Kargo Ücreti þeklinde görüntüleyiniz.

Select *
from Orders o
inner join Employees emp
on emp.EmployeeID=o.EmployeeID
inner join Shippers sh
on sh.ShipperID=o.ShipVia
where sh.CompanyName='Federal Shipping' and FirstName='Nancy'


--Herbir ürünümüzden toplam kaç adet satýlmýþtýr ve ürün bazlý ciromuz ne kadardýr?
--ProductName, CategoryName,Toplam Satýlan Adet, Toplam Ciro

Select ProductName,
CategoryName,
SUM(Quantity) [Toplam Satýlan Adet],
ROUND(SUM((od.UnitPrice*Quantity)*(1-Discount)),2) [Ürün Bazlý Ciro]
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by ProductName,CategoryName
order by [Ürün Bazlý Ciro] desc

