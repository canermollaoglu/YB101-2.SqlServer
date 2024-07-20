/*
TRANSACTION MANTI�I
Birbiri ard�na yap�lmas� gereken i�lemlerde kullan�l�r. Transaction prensip olarak ya b�t�n i�lemleri yapar, ya hi�birini ger�ekle�tirmez ya da bizim belirledi�imiz noktaya kadar geri d�ner. ��lemlerden bir tanesi yap�lmad���nda t�m i�lemleri yap�lmam�� kabul eder. 
*/

--BankamatikDB olu�tural�m
Create database BankamatikDB

use BankamatikDB

Create table Hesap(
HesapID int primary key identity(1,1),
TCKimlik char(11),
AdSoyad nvarchar(100),
Bakiye money
)

insert into Hesap values('21100212252','Ahmet Aksakal',8500)
insert into Hesap values('21199545565','Mustafa Ya�an',1500)

Select * from Hesap

--G�nderen tc, al�c� tc ve bakiye girilen bir SP yaparak i�lemi ger�ekle�tirelim:

Create Proc SP_HavaleYap(
@gonderenTC char(11),
@aliciTC char(11),
@bakiye money
)
AS
BEGIN TRY
--G�nderen hesaptan paray� �ekelim:
Update Hesap
Set Bakiye-=@bakiye
where TCKimlik=@gonderenTC

RAISERROR('',16,1)

--Hata Mesaj�	: Olu�an hata i�in bir mesaj i�erir.
--Hata Seviyesi : Hatan�n �nem derecesi. 1 ile 25 aras�nda de�er al�r. 16 kodu kullan�c� tan�ml� hatalar i�in kullan�l�r.
--Durum			: Hatan�n i�letim sistemi �zerinde etkili olup olmad���n� g�sterir.

--Al�c�n�n hesab�na para yat�r�l�yor:
Update Hesap
Set Bakiye+=@bakiye
where TCKimlik=@aliciTC
END TRY
BEGIN CATCH
	print 'Beklenmedik bir hata olu�tu.'
END CATCH


Create Proc SP_TransactionHavaleYap(
@gonderenTC char(11),
@aliciTC char(11),
@bakiye money
)
AS
BEGIN TRY
	BEGIN TRANSACTION
--G�nderen hesaptan paray� �ekelim:
Update Hesap
Set Bakiye-=@bakiye
where TCKimlik=@gonderenTC

RAISERROR('',16,1)

--Hata Mesaj�	: Olu�an hata i�in bir mesaj i�erir.
--Hata Seviyesi : Hatan�n �nem derecesi. 1 ile 25 aras�nda de�er al�r. 16 kodu kullan�c� tan�ml� hatalar i�in kullan�l�r.
--Durum			: Hatan�n i�letim sistemi �zerinde etkili olup olmad���n� g�sterir.

--Al�c�n�n hesab�na para yat�r�l�yor:
Update Hesap
Set Bakiye+=@bakiye
where TCKimlik=@aliciTC
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
	print 'Beklenmedik bir hata olu�tu.'
END CATCH


Create Proc SP_TransactionCommitHavaleYap(
@gonderenTC char(11),
@aliciTC char(11),
@bakiye money
)
AS
BEGIN TRY
	BEGIN TRANSACTION

	--Hesap a�ma i�lemi tan�mlayal�m:
	Insert into Hesap values('43344545565','Kuzey Mollao�lu',9000)

	SAVE TRANSACTION HesapAcmaIslemi

	--G�nderen hesaptan paray� �ekelim:
	Update Hesap
	Set Bakiye-=@bakiye
	where TCKimlik=@gonderenTC

	RAISERROR('',16,1)

--Al�c�n�n hesab�na para yat�r�l�yor:
	Update Hesap
	Set Bakiye+=@bakiye
	where TCKimlik=@aliciTC
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION HesapAcmaIslemi
	print 'Beklenmedik bir hata olu�tu.'
END CATCH

select * from Hesap

exec SP_TransactionCommitHavaleYap '43344545565','21199545565',500

--Bir e-ticaret sitesi incelenerek EticaretDB olu�turulacakt�r.DDL ve DML komutlar� kullan�larak veritaban�, tablo yap�lar�, constraint yap�lar� ve database diagram olu�turulacakt�r. Database Diagram ve Sorgu �eklinde teslim edilecektir. Deadline:  03.06.2024 Pazartesi 13:00

