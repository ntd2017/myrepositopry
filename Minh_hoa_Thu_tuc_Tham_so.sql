SELECT COUNT(*)
FROM EMPLOYEES
WHERE DEPARTMENT_ID=80
--
SELECT COUNT(*)
FROM EMPLOYEES
WHERE DEPARTMENT_ID=50
--
SELECT COUNT(*)
FROM EMPLOYEES
WHERE DEPARTMENT_ID=90
--
EXEC spud_Dem_nhan_vien 90
GO
--Minh họa tham số đầu vào
USE QLSINHVIEN
GO
SELECT * FROM KET_QUA WHERE Ma_sinh_vien='C01'
GO
CREATE PROC Tinh_diem_trung_binh @Ma_sinh_vien char(3)
AS
	DECLARE @dtb decimal(3,1)
	--
	SELECT @dtb = AVG(Diem)
	FROM KET_QUA WHERE Ma_sinh_vien=@Ma_sinh_vien
	--
	PRINT CONCAT(N'Điểm trung bình: ', @dtb)
GO
EXEC Tinh_diem_trung_binh 'C01'
EXEC Tinh_diem_trung_binh @Ma_sinh_vien='C01'
GO
--Tham số đầu ra
CREATE PROC spud_Tong @a INT, @b INT, @Tong INT OUT
AS
	--Tính tổng
	SET @Tong = @a + @b
GO
-- Gọi thực hiện
DECLARE @Tong INT
EXEC spud_Tong 25, 67, @Tong OUT
PRINT N'Tổng là: ' + STR(@Tong)
GO
--
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
EXEC spud_In_Thong_tin_SV 'C03'
GO
--Tham số lấy giá trị mặc định
CREATE PROC spud_Danh_sach_sinh_vien @Ma_khoa char(2)
AS
	SELECT *
	FROM SINH_VIEN
	WHERE Ma_khoa=@Ma_khoa
GO
EXEC spud_Danh_sach_sinh_vien 'VL'
EXEC spud_Danh_sach_sinh_vien 'CN'
GO
ALTER PROC spud_Danh_sach_sinh_vien @Ma_khoa char(2) = NULL
AS
	IF @Ma_khoa IS NOT NULL
		SELECT *
		FROM SINH_VIEN
		WHERE Ma_khoa=@Ma_khoa
	ELSE
		SELECT *
		FROM SINH_VIEN
GO
EXEC spud_Danh_sach_sinh_vien 'VL'
EXEC spud_Danh_sach_sinh_vien
GO
--Làm BT
USE HumanResource
GO
--
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID=90
--
BEGIN TRAN
UPDATE EMPLOYEES
SET SALARY = SALARY + SALARY*100/100
WHERE DEPARTMENT_ID=90
--
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID=90
--
ROLLBACK
--
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID=90
GO



