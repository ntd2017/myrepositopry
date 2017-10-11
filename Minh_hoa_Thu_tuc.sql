--CT tính tổng hai số nguyên a và b. In kết quả tổng
DECLARE @a int=34, @b int=25
DECLARE @tong int
--
SET @tong = @a + @b
--
PRINT CONCAT(N'Tổng của ',@a,' + ',@b,' = ',@tong)
GO
--Viết thủ tục
CREATE DATABASE TestDB
GO
USE TestDB
GO
--1. Tạo
CREATE PROC Tinh_Tong @a int, @b int
AS
	DECLARE @tong int
	--
	SET @tong = @a + @b
	--
	PRINT CONCAT(N'Tổng của ',@a,' + ',@b,' = ',@tong)
GO
--2. Gọi thực hiện
EXEC Tinh_Tong 12, 45
GO
--CT vẽ tam giác vuông cân với cạnh N=20
DECLARE @N int=20
DECLARE @i int=1
WHILE @i<=@N
BEGIN
	PRINT REPLICATE('* ',@i)
	SET @i = @i+1
END
GO
--Viết thủ tục
CREATE PROC Ve_tam_giac_vuong_can @N int
AS
	DECLARE @i int=1
	WHILE @i<=@N
	BEGIN
		PRINT REPLICATE('* ',@i)
		SET @i = @i+1
	END
GO
EXEC Ve_tam_giac_vuong_can 10
EXEC Ve_tam_giac_vuong_can 30
GO
CREATE PROC Tinh_Tuoi @Ngay_sinh datetime
AS
	DECLARE @Tuoi tinyint
	SET @Tuoi = YEAR(GETDATE()) - YEAR(@Ngay_sinh)
	PRINT CONCAT(N'Tuổi của bạn: ', @Tuoi)
GO
EXEC Tinh_Tuoi '12/24/1977'
GO
--
PRINT UPPER('abcdef')
EXEC sp_help 'Tinh_Tuoi'
EXEC sp_helptext'Tinh_Tuoi'


