/*
DML KOMUTLARI
Insert, Update, Delete
*/

--Insert (Tabloya veri eklemek i�in kullan�l�r)
Insert into Egitmen(Adi,Soyadi,UzmanlikAlani)
values('Ahmet','Aksakal','Java')

--Ad Soyad alanlar�n� bo� ge�ilemez yapal�m:
Alter table Egitmen
alter column Adi nvarchar(50) not null

Alter table Egitmen
alter column Soyadi nvarchar(50) not null

Insert into Egitmen(Adi,Soyadi)
values ('Kuzey','Mollao�lu')

--T�m alanlara veri g�ndermek gerekir.
Insert into Egitmen 
values('Cengiz','Uzun','cuzun@gmail.com','.NET')

--Bulk Insert (Y���n halde insert)

/*
Insert into
select
*/

--E�itmen tablomuzdaki b�t�n e�itmenlerimizi ��rencimiz olarak ��renci tablosuna y���n(toplu halde) kaydedelim.

alter table Ogrenci
alter column TCKimlik char(11) null

Insert into Ogrenci(Adi,Soyadi)
Select Adi,Soyadi from Egitmen

select * from Ogrenci

--Egitmen Tablosunu Tamamen Kald�ral�m:
Drop table Egitmen

--Egitmen Tablosundaki T�m Verileri Silelim:
Truncate table Egitmen

--Egitmen Tablosuna Yeni Bir Sutun Ekleme:
Alter Table Egitmen
add TelefonNo char(11)

--Constraint Kald�rma
Alter Table SinavSonuc
drop constraint FK_SinavSonuc_Ogrenci


--UPDATE (G�ncelleme)

Update Egitmen
set Email='m.kuzey@gmail.com',UzmanlikAlani='.NET'
where EgitmenID=2

select * from Egitmen

--DELETE (Silme ��lemi)
Delete from Egitmen
where EgitmenID=2

--Bir e�itmen kaydedelim ve bu e�itmene ait 2 adet kurs kayd� ger�ekle�tirelim.

select * from Egitmen
select * from Kurs

insert into Egitmen(Adi,Soyadi)
values('Merve','G�nd�z')

--De�i�ken Tan�mlama
Declare @sonID int

Select @sonID=SCOPE_IDENTITY()

Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('Yetenek Ba�aksehir Grp1','01.05.2024','01.10.2024',@sonID)

Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('Yetenek Ba�aksehir Grp2','01.05.2024','01.10.2024',@sonID)

/*
WHILE (<ko�ul ifadesi>)
	BEGIN
	<kodlar buraya yaz�lacak>
	END
*/

--��renci tablomuza demo olarak 10 adet ��renci giri�i yapal�m
Declare @counter int
set @counter=1

WHILE (@counter<=10)
	BEGIN
			Insert into Ogrenci(Adi,Soyadi)
			values ('��renci Ad�'+CAST(@counter as varchar(max)),'��renci Soyadi'+CAST(@counter as varchar(max)))
			set @counter+=1
	END

	select * from Ogrenci

