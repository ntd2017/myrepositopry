--Tăng lương 10% cho các nhân viên
USE HumanResource
GO
--1. Lệnh
UPDATE EMPLOYEES
SET SALARY = SALARY*1.1, FIRST_NAME = UPPER(FIRST_NAME)
GO
--2. Thủ tục
CREATE PROC spud_Tang_luong
AS
	UPDATE EMPLOYEES
	SET SALARY = SALARY*1.1
GO
--Gọi thực hiện
EXEC spud_Tang_luong
GO
--3.
ALTER PROC spud_Tang_luong @Phan_tram INT
AS
	DECLARE @Ty_le DECIMAL(3,1) = 1 + @Phan_tram/100
	UPDATE EMPLOYEES
	SET SALARY = SALARY*@Ty_le
GO
--Gọi thực hiện
EXEC spud_Tang_luong @Phan_tram=10
GO
--Sử dụng các thủ tục Hệ thống để tạo login và user
USE master
GO
EXEC sp_addlogin @loginame='tom', @passwd='tomabc'
GO  
USE HumanResource
GO
EXEC sp_adduser @loginame='tom', @name_in_db='tom'
GO
--Thủ tục tính tổng hai số nguyên và in ra kết quả tổng
CREATE PROC spud_Tong @a INT , @b INT
AS
	--Khai báo biến
	DECLARE @Tong INT
	--Tính tổng
	SET @Tong = @a + @b
	--In kết quả tổng
	PRINT CONCAT(N'Tổng của ',@a,N' và ',@b,N' là: ',@Tong)
GO
EXEC spud_Tong 34,25
EXEC spud_Tong @a=34, @b=25
GO
--Tham số đầu vào
CREATE PROC spud_Dem_nhan_vien @depid INT
AS
	SET NOCOUNT ON
	--Khai báo biến
	DECLARE @Dem INT
	--Đếm số nhân viên của phòng
	SELECT @Dem = COUNT(*)
	FROM EMPLOYEES
	WHERE department_id=@depid
	--In kết quả đếm được
	PRINT N'Tổng số nhân viên: ' + STR(@Dem)
GO
EXEC spud_Dem_nhan_vien @depid=50
GO
--Tham số đầu ra
ALTER PROC spud_Tong @a INT, @b INT, @Tong INT OUT
AS
	--Tính tổng
	SET @Tong = @a + @b
GO
--
DECLARE @Tong INT
EXEC spud_Tong 25, 67, @Tong OUT
PRINT N'Tổng là: ' + STR(@Tong)
GO
--Đọc và in ra Họ tên của sinh viên C01
USE QLSinhVien
GO
CREATE PROC spud_In_Thong_tin_SV @Ma_sinh_vien CHAR(3)
AS
	SET NOCOUNT ON
	DECLARE @Ho_ten NVARCHAR(50)
	--
	SELECT @Ho_ten = Ho_sinh_vien + ' ' + Ten_sinh_vien
	FROM SINH_VIEN
	WHERE Ma_sinh_vien=@Ma_sinh_vien
	--
	PRINT N'Họ tên: ' + @Ho_ten
GO
EXEC spud_In_Thong_tin_SV 'C01'
GO
EXEC spud_In_Thong_tin_SV @Ma_sinh_vien='C01'
GO
DECLARE @Ma_sinh_vien CHAR(3) = 'C01'
EXEC spud_In_Thong_tin_SV @Ma_sinh_vien
GO
CREATE PROC spud_Doc_Thong_tin_SV @Ma_sinh_vien CHAR(3),
	@Ho_sinh_vien NVARCHAR(30) OUT, @Ten_sinh_vien NVARCHAR(20) OUT
AS
	SET NOCOUNT ON
	--
	SELECT @Ho_sinh_vien = Ho_sinh_vien, @Ten_sinh_vien = Ten_sinh_vien
	FROM SINH_VIEN
	WHERE Ma_sinh_vien=@Ma_sinh_vien
GO
--
DECLARE @Ma_sinh_vien CHAR(3) = 'C01'
DECLARE @Ho_sinh_vien NVARCHAR(30), @Ten_sinh_vien NVARCHAR(20)
EXEC spud_Doc_Thong_tin_SV @Ma_sinh_vien, @Ho_sinh_vien OUT, @Ten_sinh_vien OUT
PRINT N'Họ tên: ' + @Ho_sinh_vien + ' ' + @Ten_sinh_vien
GO
--Kiểu TABLE do người lập trình định nghĩa
USE QLBanHang
GO
CREATE TYPE Kieu_NCC AS TABLE
(
	Ma CHAR(3) PRIMARY KEY,
	Ten NVARCHAR(100),
	Dia_chi NVARCHAR(200)
)
GO
DECLARE @Danh_sach Kieu_NCC
--
INSERT INTO @Danh_sach VALUES('T05', N'Công ty Hừng Sáng', N'246 An Dương Vương')
INSERT INTO @Danh_sach VALUES('T06', N'Công ty Tầm Cao', N'123 Nguyễn Trãi')
INSERT INTO @Danh_sach VALUES('T07', N'Công ty Hoàng Hôn', N'345 Bình Thới')
--
SELECT * FROM @Danh_sach
GO
CREATE PROC spud_Them_NCC @Danh_sach Kieu_NCC  READONLY 
AS
	SET NOCOUNT ON
	--
	INSERT INTO NHACC(MaNhaCC, TenNhaCC, DiaChi)
	SELECT Ma, Ten, Dia_chi FROM @Danh_sach
GO
--
DECLARE @Danh_sach Kieu_NCC
--
INSERT INTO @Danh_sach VALUES('T05', N'Công ty Hừng Sáng', N'246 An Dương Vương')
INSERT INTO @Danh_sach VALUES('T06', N'Công ty Tầm Cao', N'123 Nguyễn Trãi')
INSERT INTO @Danh_sach VALUES('T07', N'Công ty Hoàng Hôn', N'345 Bình Thới')
--
EXEC spud_Them_NCC @Danh_sach
GO
SELECT * FROM NHACC
GO
--
USE QLSinhVien
GO
CREATE TYPE Kieu_Ket_qua AS TABLE
(
	Ma_sinh_vien CHAR(3),
	Ma_mon_hoc CHAR(2),
	Diem REAL CHECK(Diem BETWEEN 0 AND 10),
	PRIMARY KEY(Ma_sinh_vien, Ma_mon_hoc)
)
GO
--Kiểu XML
--Khai báo biến kiểu XML
DECLARE @Danh_sach XML
DECLARE @Chuoi NVARCHAR(1000)
--Gán dữ liệu XML cho biến
SET @Chuoi = '<DANH_SACH><SO Gia_tri="12"/>' + '<SO Gia_tri="34"/>' + '<SO Gia_tri="21"/>' + '</DANH_SACH>'
SET @Danh_sach = CAST(@Chuoi AS XML)
--In
PRINT CAST(@Danh_sach AS NVARCHAR(1000))
SELECT @Danh_sach
--Truy vấn
SELECT So.value('@Gia_tri', 'integer') Gia_tri
FROM @Danh_sach.nodes('/DANH_SACH/SO') AS Danh_sach (So)
GO
USE QLBanHang
GO
CREATE PROC spud_Tong @Danh_sach XML, @Tong INT OUT
AS
	SET NOCOUNT ON
	--Tính tổng
	SELECT @Tong = SUM(So.value('@Gia_tri', 'integer'))
	FROM @Danh_sach.nodes('/DANH_SACH/SO') AS Danh_sach (So)
GO
DECLARE @Danh_sach XML
DECLARE @Chuoi NVARCHAR(1000)
--Gán dữ liệu XML cho biến
SET @Chuoi = '<DANH_SACH><SO Gia_tri="12"/>' + '<SO Gia_tri="34"/>' + '<SO Gia_tri="21"/>' + '</DANH_SACH>'
SET @Danh_sach = CAST(@Chuoi AS XML)
--Gọi thực hiện thủ tục
DECLARE @Tong INT
EXEC spud_Tong @Danh_sach, @Tong OUT
PRINT N'Tổng là: ' + STR(@Tong)
GO
CREATE PROC spud_Tong @Danh_sach XML, @Ket_qua XML OUT
AS
	SET NOCOUNT ON
	DECLARE @Tong INT
	--Tính tổng
	SELECT @Tong = SUM(So.value('@Gia_tri', 'integer'))
	FROM @Danh_sach.nodes('/DANH_SACH/SO') AS Danh_sach (So)
	--
	DECLARE @Chuoi NVARCHAR(1000) = '<KET_QUA Tong="{0}" />'
	SET @Chuoi = REPLACE(@Chuoi,'{0}',@Tong)
	SET @Ket_qua = CAST(@Chuoi AS XML)
GO
DECLARE @Danh_sach XML
DECLARE @Chuoi NVARCHAR(1000)
--Gán dữ liệu XML cho biến
SET @Chuoi = '<DANH_SACH><SO Gia_tri="12"/>' + '<SO Gia_tri="34"/>' + '<SO Gia_tri="21"/>' + '</DANH_SACH>'
SET @Danh_sach = CAST(@Chuoi AS XML)
--Gọi thực hiện thủ tục
DECLARE @Tong INT, @Ket_qua XML
EXEC spud_Tong @Danh_sach, @Ket_qua OUT
SELECT @Ket_qua
SELECT @Tong = Dong.value('@Tong', 'integer')
	FROM @Ket_qua.nodes('/KET_QUA') AS Ket_qua (Dong)
PRINT N'Tổng là: ' + STR(@Tong)
GO
--Biến kiểu CURSOR
USE QLSinhVien
GO
DECLARE @cur CURSOR
SET @cur = CURSOR FOR 
					SELECT Ho_sinh_vien + ' ' + Ten_sinh_vien AS Ho_ten, Ngay_sinh, Gioi_tinh  
					FROM SINH_VIEN WHERE Ma_sinh_vien='C01'
DECLARE @ho_ten NVARCHAR(50), @ngay_sinh AS DATE, @gioi_tinh AS BIT
--Mở Cursor
OPEN @cur
--Đọc dòng hiện hành trong Cursor ra biến
FETCH NEXT FROM @cur INTO @ho_ten, @ngay_sinh, @gioi_tinh
--Xử lý in
PRINT N'Họ tên: ' + @ho_ten
PRINT N'Ngày sinh: ' + FORMAT(@ngay_sinh,'dd/MM/yyyy')
PRINT N'Phái: ' + IIF(@gioi_tinh=1,N'Nam',N'Nữ')
--Đóng Cursor
CLOSE @cur
--Giải phóng vùng nhớ Cursor
DEALLOCATE @cur
GO
--Tham số OUT kiểu CURSOR
CREATE PROC spud_Cursor_Test @Ma_sinh_vien CHAR(3), @cur CURSOR VARYING OUTPUT
AS
	--Gán
	SET @cur = CURSOR FOR 
						SELECT Ho_sinh_vien + ' ' + Ten_sinh_vien AS Ho_ten, Ngay_sinh, Gioi_tinh  
						FROM SINH_VIEN WHERE Ma_sinh_vien=@Ma_sinh_vien
	--Mở
	OPEN @cur
GO
--Test ...
DECLARE @cur CURSOR
EXEC spud_Cursor_Test 'C01', @cur OUT
DECLARE @ho_ten NVARCHAR(50), @ngay_sinh AS DATE, @gioi_tinh AS BIT
--Đọc dòng hiện hành trong Cursor ra biến
FETCH NEXT FROM @cur INTO @ho_ten, @ngay_sinh, @gioi_tinh
--Xử lý in
PRINT N'Họ tên: ' + @ho_ten
PRINT N'Ngày sinh: ' + FORMAT(@ngay_sinh,'dd/MM/yyyy')
PRINT N'Phái: ' + IIF(@gioi_tinh=1,N'Nam',N'Nữ')
--Đóng Cursor
CLOSE @cur
--Giải phóng vùng nhớ Cursor
DEALLOCATE @cur
GO
USE HumanResource
GO
--
EXEC sp_help spud_Tong
EXEC sp_helptext spud_Tong
GO
CREATE PROC spud_Tang_luong @Phan_tram INT
WITH ENCRYPTION
AS
	DECLARE @Ty_le DECIMAL(3,1) = 1 + @Phan_tram/100
	UPDATE EMPLOYEES
	SET SALARY = SALARY*@Ty_le
GO
--Sử dụng bảng tạm
--Lệnh RETURN
USE QLBanHang
GO
CREATE PROC spud_Xem_DDH @Manhacc CHAR(3)
AS
	SET NOCOUNT ON
	--
	PRINT N'Danh sách đơn ĐH'
	SELECT *
	FROM DONDH
	WHERE MaNhaCC=@Manhacc
GO
EXEC spud_Xem_DDH @Manhacc='C02'
GO
ALTER PROC spud_Xem_DDH @Manhacc CHAR(3)
AS
	SET NOCOUNT ON
	--Kiểm tra Ma nha cung cap truyen vao
	IF NOT EXISTS(SELECT NULL FROM NHACC WHERE MaNhaCC=@Manhacc)
	BEGIN
		PRINT N'Mã nhà cung cấp không hợp lệ!'
		RETURN
	END
	IF NOT EXISTS(SELECT NULL FROM DONDH WHERE MaNhaCC=@Manhacc)
	BEGIN
		PRINT N'Nhà cung cấp này chưa có đơn đặt hàng nào!'
		RETURN
	END
	--
	PRINT N'Danh sách đơn ĐH'
	SELECT *
	FROM DONDH
	WHERE MaNhaCC=@Manhacc
	--
	RETURN
GO
EXEC spud_Xem_DDH @Manhacc='C00'
EXEC spud_Xem_DDH @Manhacc='C07'
EXEC spud_Xem_DDH @Manhacc='C02'
GO
ALTER PROC spud_Xem_DDH @Manhacc CHAR(3)
AS
	SET NOCOUNT ON
	--Kiểm tra Mã nhà cung cấp truyền vào
	IF NOT EXISTS(SELECT NULL FROM NHACC WHERE MaNhaCC=@Manhacc)
	BEGIN
		RETURN 1
	END
	IF NOT EXISTS(SELECT NULL FROM DONDH WHERE MaNhaCC=@Manhacc)
	BEGIN
		RETURN 2
	END
	--
	PRINT N'Danh sách đơn ĐH'
	SELECT *
	FROM DONDH
	WHERE MaNhaCC=@Manhacc
	--
	RETURN 0
GO
--
DECLARE @tra_ve INT
EXEC @tra_ve = spud_Xem_DDH @Manhacc='C00'
PRINT CONCAT(N'Trả về --> ',@tra_ve) + CHAR(13)
EXEC @tra_ve = spud_Xem_DDH @Manhacc='C07'
PRINT CONCAT(N'Trả về --> ',@tra_ve) + CHAR(13)
EXEC @tra_ve = spud_Xem_DDH @Manhacc='C02'
PRINT CONCAT(N'Trả về --> ',@tra_ve) + CHAR(13)
GO
DECLARE @Manhacc CHAR(3) = 'C02'
DECLARE @tra_ve INT
EXEC @tra_ve = spud_Xem_DDH @Manhacc
IF @tra_ve=1
	PRINT N'Mã nhà cung cấp không hợp lệ!'
ELSE IF @tra_ve=2
	PRINT N'Nhà cung cấp này chưa có đơn đặt hàng nào!'
ELSE
	PRINT N'Thành công'
GO
