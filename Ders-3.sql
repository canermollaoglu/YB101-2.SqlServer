--�r�n kategorilerine g�re adet bazl� sat��lar� listeleyelim.

Select c.CategoryName,Sum(Quantity)
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by c.CategoryName

--�al��anlar�m �r�n baz�nda ne kadarl�k sat�� yapm��lar. (�al��an Ad�, �r�n Ad�, Adet, Ciro)
--Top N kayd�n getirmesi

Select top 5 FirstName+' '+LastName AdSoyad,ProductName,Sum(Quantity) Adet,
Round(Sum((od.UnitPrice*Quantity)*(1-Discount)),2) Ciro
from [Order Details] od
inner join Orders o
on o.OrderID=od.OrderID
inner join Employees emp
on emp. EmployeeID=o.EmployeeID
inner join Products p
on p.ProductID=od.ProductID
group by FirstName+' '+LastName,ProductName
order by Ciro desc

--OUTER JOIN (Left Outer Join, Right Outer Join)
--Left ve Right Outer Join 

Select EmployeeID from Employees
select Distinct(EmployeeID) from Orders

Select * from Employees where EmployeeID 
not in(Select EmployeeID from Orders)

--830 sat�r kay�t geldi. 
Select *
from Employees emp
inner join Orders o
on o.EmployeeID=emp.EmployeeID

--831 sat�r kay�t geldi.
--Left Outer Join: e�le�menin sol taraf�nda kalan tablodaki t�m sat�rlar� getirir.
Select *
from Employees emp left join Orders o
on o.EmployeeID=emp.EmployeeID

--831 sat�r kay�t geldi.
--Right Outer Join: e�le�menin sa� taraf�nda kalan tablodaki t�m sat�rlar� getirir.
Select *
from Orders o right join Employees emp
on o.EmployeeID=emp.EmployeeID

--CROSS JOIN
--�reticilerimizin �al��abilece�i t�m kargo sirketi alternatiflerini listeyiniz.
--Shippers > 3 adet
--Suppliers > 29 adet
--Sonu�: 87 sat�r kay�t �retildi.
Select * from Shippers
CROSS JOIN Suppliers

--UNION
--�ki veya daha fazla select sorgusunun sonu�lar�n� tek bir sorguda birle�tirir.
--G�r�nt�lenecek clon sat�rlar ayn� veri t�r�nde, ayn� say�da ve ayn� d�zende olmal�d�r.

Select Lower(REPLACE(Left(EmailName,5),' ','')+'@istanbulegitimakademi.com') from
(Select CompanyName EmailName,City from Customers
UNION
Select FirstName+' '+LastName,City from Employees
UNION
Select CompanyName,'-' from Shippers
UNION
Select CompanyName,City from Suppliers) tablo

--DDL KOMUTLARI
--Create, Alter, Drop

/*
char(10)		"Ali"       10 byte
varchar(10)		"Ali"		3 byte
nvarchar(10)	"Ali"		3 byte bu t�m alfabelerin harflerini ve karakter setlerini i�eren UNICODE karakter setinde bir de�i�ken tan�mlam�m�z� sa�lar.
*/

Create Database KursDB 
use KursDB

Create Table Egitmen(
EgitmenID int primary key identity(1,1),
Adi nvarchar(50),
Soyadi nvarchar(50),
Email nvarchar(50),
UzmanlikAlani nvarchar(100)
)

Create Table Kurs(
KursID int primary key identity(1,1),
KursAdi nvarchar(120) not null,
BaslangicTarihi date,
BitisTarihi date,
EgitmenID int
)

ALTER TABLE Kurs
ADD CONSTRAINT FK_Kurs_Egitmen 
FOREIGN KEY(EgitmenID) 
REFERENCES Egitmen(EgitmenID)

Create Table Ders(
DersID int primary key identity(1,1),
DersAdi nvarchar(200) not null,
KursID int,
Foreign key(KursID) references Kurs(KursID)
)

Create Table Ogrenci(
OgrenciID int primary key identity(1,1),
Adi nvarchar(50) not null,
Soyadi nvarchar(50) not null,
DogumTarihi date,
TCKimlik char(11) not null
)

 Create Table Sinav(
 SinavID int primary key identity(1,1),
 SinavAdi nvarchar(100),
 SinavTarihi date
 )

 --Bir ��renci birden �ok kursa kay�t olabilir.
 --Bir kurs i�erisinde birden �ok ��renci yer alabilir.
 --Bu nedenle Ogrenci ve Kurs tablolar� aras�na bir ara tablo(Kayit) yap�yoruz.

 Create Table Kayit(
 KayitID int primary key identity(1,1),
 KayitTarihi date,
 KursID int,
 OgrenciID int,
 foreign key(KursID) references Kurs(KursID),
 foreign key(OgrenciID) references Ogrenci(OgrenciID)
 )

 --Composite Key
 --SQL'de bile�ik anahtar (composite key), birden fazla s�tunun bir araya gelerek olu�turdu�u birincil anahtar veya benzersiz anahtar anlam�na gelir. Bile�ik anahtar, tek bir s�tunun benzersizli�i sa�lamak i�in yeterli olmad��� durumlarda kullan�l�r. 

 Create Table SinavSonuc(
 OgrenciID int,
 SinavID int,
 Notu tinyint,
 primary key(OgrenciID,SinavID)
 )

 Alter table SinavSonuc
 add constraint FK_SinavSonuc_Ogrenci
 foreign key(OgrenciID) references Ogrenci(OgrenciID)

 Alter table SinavSonuc
 add constraint FK_SinavSonuc_Sinav
 foreign key(SinavID) references Sinav(SinavID)