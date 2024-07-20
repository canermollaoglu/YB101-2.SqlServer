/*
SQL NED�R? (Structured Query Language)
Sql bir veritaban� sorgulama dilidir. Sql ile veritaban�na yeni tablolar, kay�tlar ekleyip silebilir, var olanlar �zerinde d�zenlemeler ve filtrelemeler yapabiliriz.

Sql ile Oracle, db2, Sybase, Informix, Microsoft Sql Server, Ms Access gibi veritaban� y�netim sistemlerinde �al��abiliriz. Sql standart bir veritaban� sorgulama dilidir ve b�t�n geli�mi� veritaban� uygulamalar�nda kullan�l�r.

T-SQL (Transact Sql)		PL-SQL

Sql'de kullan�lan komutlar 3 ana ba�l�kta toplan�r:

DDL (Data Definition Language)
Create, Alter , Drop

DML (Data Manipulation Language)
Select, Insert, Update, Delete

DCL (Data Control Language)
Grant, Deny, Revoke

Sql Server bir RDMBS'dir. (Relational DataBase Management System)
*/

--Select Ifadesi
--t�m sutunlar� getirir

USE Northwnd

SELECT * FROM Employees
SELECT * FROM Customers

--belirli sutunlari getirme

Select CustomerID,CompanyName,City,Country
from Customers

--Filtreleme (WHERE)
Select *
from Customers
where Country='Canada'

--Birim fiyat� 40 dolara e�it ya da fazla olan �r�nleri listeleyiniz.
Select *
from Products
where UnitPrice>=40


--Hangi sipari�lerin i�erisinde 11 numaral� urunden sat�n al�nm��t�r.
Select *
from [Order Details]
where ProductID=11

--Sutun �simlendirme (as)
Select FirstName+' '+LastName [Ad Soyad],EmployeeID
from Employees

--1 numaral� tedarikciye ait olan �r�nlerimiz hangileridir.

Select *
from Products
where SupplierID=1

--AND, OR, NOT Operat�rleri
--5 numaral� personelin 1998 y�l�ndan itibaren ald��� sipari�lerin listeleyelim.
Select *
from Orders
where EmployeeID=5 and OrderDate>'1998'

--Berlindeki ve Amerikadaki �reticileri listelemek istiyoruz.

Select *
from Suppliers
where City='Berlin' or Country='USA'

--1 ve 2 nolu �reticilerin 20$ dan pahal� olan �r�nlerini listeleyiniz.
Select *
from Products
where UnitPrice>20 and (SupplierID=1 or SupplierID=2)

--Sipari�leri EmployeeID'ye g�re s�ralay�n�z

Select *
from Orders
order by EmployeeID asc

Select *
from Orders
order by EmployeeID desc

--Stok miktar� 50 den fazla olan �r�nleri listeleyelim.

Select *
from Products
where UnitsInStock>50
order by UnitsInStock desc

--Between .... and
--iki de�er aral���ndaki t�m kay�tlar� getirir

Select * from Products
where UnitPrice between 35 and 65

Select *
from Customers
where CustomerID between 'ALFKI' and 'CACTU'

--Like ifadesi
--Sutundaki de�erlerin joker karakterler (%,[]) kullanarak olu�turdu�umuz bir arama kosulu ile kar��la�t�r�lmas�n� sa�lar.

Select *
from Customers
where CompanyName LIKE '%hungry%'

/*
LIKE 'K%'		: K ile ba�layan t�m kay�tlar
LIKE 'Tr%'		: Tr ile ba�layan t�m kay�tlar
LIKE ' en'		: Toplam 3 karakter olan ve son iki harfi en olan t�m kay�tlar
LIKE '[CK]%'	: C veya K ile ba�layan t�m kay�tlar
LIKE '[s-v]ing'	: ing ile biten ilk harfi s ile ve aras�nda olan d�rt harfli t�m						kay�tlar.

*/

--Bir listedeki elemanlar�n aranmas�
--Japonya ve Italyadaki �reticileri listeleyiniz.
Select *
from Suppliers
where Country='Japan' or Country='Italy'

Select *
from Suppliers 
where Country IN ('Japan','Italy')

--Japonya ve Italyada olmayan �reticileri listeleyiniz.
Select *
from Suppliers 
where Country NOT IN ('Japan','Italy')

--Bo� De�erlerin G�r�nt�lenmesi (NULL)
--Herhangi bir alana bir de�er girilmezse ve alan i�in herhangi bir varsay�lan de�er yoksa bu alan�n de�eri NULL olur. Null de�eri bo�luk '' ve 0(s�f�r) dan farkl�d�r.
--IS NULL

Select *
from Suppliers
where Region IS NULL

Select *
from Suppliers
where Region IS NOT NULL

--Hangi �lkelerde bulunan �reticiler ile �al���yoruz.
--Sutundaki benzersiz kay�tlar� getirir.
Select distinct Country
from Suppliers

--birden fazla alan i�in s�ralama yapabiliriz. 

Select *
from Products
order by CategoryID desc, UnitPrice asc

Select *
from Products
order by 4 desc, 6 asc

Select * from Orders
Select * from [Order Details]

--Adres bilgisi i�erisinde St. ge�en tedarik�ileri listeleyiniz

select *
from Suppliers
where Address like '%St.%'


--VINET id li m��terinin yapm�� oldu�u t�m siparisleri listeleyiniz.
select *
from Orders
where CustomerID='VINET'

--Londra veya Tokyo da bulunan tedarik�ilerden region bilgisi null olanlar� listeleyiniz.
select *
from Suppliers
where City in ('London','Tokyo') and region is null

--Birim fiyat� 10 dolar ile 45 dolar aras�nda olan �r�nlerden kategorisi 2 olanlar� listeleyiniz.

select *
from Products	
where CategoryID=2 and UnitPrice between 10 and 45


--Kategori idsi 5 olan, Birim Fiyat� 20 ile 35 dolar aras�nda olan ve �r�n ad� i�erisinde 'gute' kelimesi ge�en �r�nleri listeleyiniz.
select *
from Products
where ProductName like '%gute%' and CategoryID=5 and UnitPrice between 20 and 35

select *
from Products
where ProductName like '%[gute]%' and CategoryID=5 and UnitPrice between 20 and 35

--Matematiksel ��lemler

select 12+3

--Birim fiyat ile miktar �arp�larak �r�n bazl� olarak toplam maliyeti bulal�m.

select OrderID,ProductID,UnitPrice,Quantity,UnitPrice*Quantity TotalCost
from [Order Details]
order by TotalCost desc

--TotalCost 15000 dolardan fazla olan sipari�leri listeleyiniz.
select OrderID,ProductID,UnitPrice,Quantity,(UnitPrice*Quantity) TotalCost
from [Order Details]
where (UnitPrice*Quantity)>15000
order by TotalCost desc





