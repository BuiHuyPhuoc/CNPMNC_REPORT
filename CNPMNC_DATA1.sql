﻿use master
go

if exists (select* from sysdatabases where name = 'CNPMNC_DATA1')
	drop database CNPMNC_DATA1
go

create database CNPMNC_DATA1
go

use CNPMNC_DATA1
go

CREATE TABLE LOAIKH(
	MaLoaiKH INT IDENTITY(1,1) PRIMARY KEY,
	TenLKH NVARCHAR(50) NOT NULL,
	ChietKhau FLOAT
)

CREATE TABLE KHACHHANG(
	MaKH INT IDENTITY(1,1) PRIMARY KEY,
	TenTKKH VARCHAR(25) NOT NULL,
	MatKhauKH VARCHAR(30) NOT NULL,
	EmailKH VARCHAR(35) NOT NULL,
	DiemThuongKH SMALLINT NOT NULL,
	TrangThaiTKKH NVARCHAR(25) NOT NULL,
	MaLoaiKH INT REFERENCES LOAIKH(MaLoaiKH)
)

CREATE TABLE LAOINV(
	MaLoaiNV INT IDENTITY(1,1) PRIMARY KEY,
	TenLoaiNV NVARCHAR(100) NOT NULL
)

CREATE TABLE NHANVIEN(
	MaNV INT IDENTITY(1,1) PRIMARY KEY,
	HoTenNV NVARCHAR(100) NOT NULL,
	Email VARCHAR(35) NOT NULL,
	MatKhauNV VARCHAR(30) NOT NULL,
	TrangThaiTKNV NVARCHAR(25) NOT NULL,
	MaLoaiNV INT REFERENCES LAOINV(MaLoaiNV)
)

CREATE TABLE THELOAIP(
	MaTL INT IDENTITY(1,1) PRIMARY KEY,
	TenTL NVARCHAR(100) NOT NULL,
	MoTaTL NVARCHAR(255) NOT NULL
)

CREATE TABLE GIOIHANTUOI(
	MaGHT INT IDENTITY(1,1) PRIMARY KEY,
	TenGHT CHAR(10) NOT NULL,
	MoTaGHT NVARCHAR(255) NOT NULL
)

CREATE TABLE PHIM(
	MaPhim INT IDENTITY(1,1) PRIMARY KEY,
	TenPhim NVARCHAR(100) NOT NULL,
	TomTatP NVARCHAR(MAX) NOT NULL,
	NgayCongChieu DATE NOT NULL,
	ThoiLuongP SMALLINT NOT NULL,
	LuotMua SMALLINT CHECK (LuotMua>=0) NOT NULL,
	LuotThich SMALLINT CHECK (LuotThich>=0) NOT NULL,
	HinhAnh VARCHAR(50) NOT NULL,
	Trailer VARCHAR(100) NOT NULL,
	GiaPhim MONEY CHECK (GiaPhim>=0) NOT NULL,
	MaGHT INT REFERENCES GIOIHANTUOI(MaGHT) 
)

CREATE TABLE TL_P(
	MaTLP INT IDENTITY(1,1) PRIMARY KEY,
	MaPhim INT REFERENCES PHIM(MaPhim),
	MaTL INT REFERENCES THELOAIP(MaTL)
)

CREATE TABLE LOAIPC(
	MaLPC INT IDENTITY(1,1) PRIMARY KEY,
	TenLPC NVARCHAR(30) NOT NULL,
	MoTaLPC NVARCHAR(100) NOT NULL
)

CREATE TABLE LOAIGHE(
	MaGhe INT IDENTITY(1,1) PRIMARY KEY,
	TenLG CHAR(10) NOT NULL,
	GiaLGhe FLOAT NOT NULL
)

CREATE TABLE PHONGCHIEU(
	MaPC INT IDENTITY(1,1) PRIMARY KEY,
	TenPC NVARCHAR(30) NOT NULL,
	SLGheThuong SMALLINT CHECK (SLGheThuong>=1) NOT NULL,
	SLGheVIP SMALLINT CHECK (SLGheVIP>=1) NOT NULL,
	MaLPC INT REFERENCES LOAIPC(MaLPC)
)

CREATE TABLE GHECUAPC(
	MaPC INT REFERENCES PHONGCHIEU(MaPC),
	MaGhe INT REFERENCES LOAIGHE(MaGhe),
	TrangThaiGhePC NVARCHAR(50) NOT NULL,
	TenGhePC CHAR(10) NOT NULL,
	PRIMARY KEY (MaPC, MaGhe)
)

CREATE TABLE XUATCHIEU(
	CaXC CHAR(10) PRIMARY KEY,
	GioXC TIME NOT NULL
)

CREATE TABLE LICHCHIEU(
	MaLC INT IDENTITY(1,1) PRIMARY KEY,
	NgayLC DATE NOT NULL,
	TrangThaiLC NVARCHAR(50) NOT NULL,
	SLVeDat INT CHECK (SLVeDat>=0) NOT NULL,
	CaXC CHAR(10) REFERENCES XUATCHIEU(CaXC),
	MaPC INT REFERENCES PHONGCHIEU(MaPC),
	MaPhim INT REFERENCES PHIM(MaPhim)
)

CREATE TABLE BINHLUAN(
	MaPhim INT REFERENCES PHIM(MaPhim),
	MaKH INT REFERENCES KHACHHANG(MaKH),
	TrangThai NVARCHAR(30) NOT NULL,
	NgayTao DATE NOT NULL,
	PRIMARY KEY (MaPhim, MaKH)
)

CREATE TABLE YEUTHICH(
	MaPhim INT REFERENCES PHIM(MaPhim),
	MaKH INT REFERENCES KHACHHANG(MaKH),
	PRIMARY KEY (MaPhim, MaKH)
)

CREATE TABLE VEPHIM(
	MaVe INT IDENTITY(1,1) PRIMARY KEY,
	NgayDat DATETIME NOT NULL,
	TrangThaiThanhToan NVARCHAR(20) NOT NULL,
	TrangThaiHetHan NVARCHAR(20) NOT NULL,
	SLGhe SMALLINT NOT NULL CHECK (SLGhe>=0),
	GiaVe MONEY NOT NULL,
	MaLC INT REFERENCES LICHCHIEU(MaLC),
	MaKH INT REFERENCES KHACHHANG(MaKH)
)

CREATE TABLE VE_GHE(
	MaVe INT REFERENCES VEPHIM(MaVe),
	TenGheVG CHAR(10) NOT NULL,
	PRIMARY KEY (MaVe)
)

CREATE TABLE HOADON(
	MaHD INT IDENTITY(1,1) PRIMARY KEY,
	NgayTao DATETIME NOT NULL,
	TongGiaHD MONEY NOT NULL,
	TongGiaSauGiam MONEY NOT NULL,
	TiLeGG FLOAT NOT NULL,
	MaNV INT REFERENCES NHANVIEN(MaNV)
)

CREATE TABLE CHITIETHD(
	MaVe INT REFERENCES VEPHIM(MaVe),
	MaHD INT REFERENCES HOADON(MaHD),
	SoLuongVe SMALLINT CHECK (SoLuongVe>=1) NOT NULL,
	ThanhTienVe MONEY NOT NULL,
	PRIMARY KEY (MaVe, MaHD)
)

INSERT INTO GIOIHANTUOI values ('P', N'Mọi lứa tuổi')
INSERT INTO GIOIHANTUOI values ('P13', N'Trên 13 tuổi')
INSERT INTO GIOIHANTUOI values ('P16', N'Trên 16 tuổi')
INSERT INTO GIOIHANTUOI values ('P18', N'Trên 18 tuổi')

INSERT INTO PHIM VALUES
(N'ÁN MẠNG Ở VENICE', 
N'Dựa trên tiểu thuyết Halloween Party của nhà văn Agatha Christie, hành trình phá án của thám tử Hercule Poirot tiếp tục được đưa lên màn ảnh rộng.',
'20230915',103,0,0,'anmangovenice.png',
'https://www.youtube.com/watch?v=EL8FdLQFUhc',50000,3)

INSERT INTO PHIM VALUES
(N'THE NUN', N'Là phần phim tiếp nối câu chuyện năm 2019 của The Nun, phim lấy bối cảnh nước Pháp năm 1956, 
		cùng cái chết bí ẩn của một linh mục, một giai thoại đáng sợ và ám ảnh sẽ mở ra tiếp tục xoay 
		quanh nhân vật chính - Sơ Irene. Liệu Sơ Irene có nhận ra, đây chính là hồn ma nữ tu Valak từng 
		có cuộc chiến “sống còn” với cô không lâu trước đây.','20230908',110,10,0,
		'thenun.png','https://www.youtube.com/watch?v=vab6sPIceuU',50000,4)
	
INSERT INTO PHIM VALUES
(N'BIỆT ĐỘI ĐÁNH THUÊ 4', N'Biệt Đội Đánh Thuê - gồm cả các gương mặt kỳ cựu và những tân binh - đã bắt đầu một nhiệm vụ mới. 
		Lần này, họ sẽ tới một nhà máy vũ khí hạt nhân cũ tại Qadhafi để tóm gọn Suharato Rahmat, kẻ đang âm 
		mưu một mình đánh cắp kíp nổ hạt nhân cho gã khách hàng xảo quyệt Ocelot. Rahmat từng là một tay buôn
		vũ khí người Anh với đội quân của riêng mình. Hắn đã thành công đánh cắp va li chứa kíp nổ trước khi
		Biệt Đội Đánh Thuê kịp tìm đến. Nếu kíp nổ rơi vào tay Ocelot, gã sẽ hủy diệt cả thế giới. 
		Sau khi nhiệm vụ tóm gọn Rahmat thất bại, cả đội tiếp tục hành trình trên con thuyền Jantara, 
		nơi bước ngoặt thực sự của câu chuyện xảy ra, và một sự thật gây sốc về Ocelot được hé lộ…','20230922',103,10,0,'bddt4.png',
		'https://www.youtube.com/watch?v=P5zcuOefk1A',50000,4)

INSERT INTO PHIM VALUES
(N'HỌA QỦY', N'Nhà khoa học thiên tài Tomohiko Kataoka được trưởng nhóm nghiên cứu Synthekai VR yêu cầu tham gia 
		cùng họ trên Đảo Abominable. Ở đó, họ đã tạo ra một không gian ảo cho toàn bộ hòn đảo và họ muốn 
		Tomohiko sử dụng các kỹ thuật tiên tiến của mình để nâng cấp dự án. Tuy nhiên, khi Tomohiko đeo kính
		VR và bước vào thế giới ảo, trời đột nhiên trở nên tối tăm và một người phụ nữ bí ẩn xuất hiện. 
		Những cái chết bí ẩn xảy ra với nhân viên công ty công nghệ VR. Có một nỗi sợ hãi chưa từng có 
		đang chờ đợi giữa thực tế và thế giới ảo.','20230908',107,10,0,'hoaquy.png',
		'https://www.youtube.com/watch?v=WUuMNNqzEO0',50000,4)

INSERT INTO PHIM VALUES
(N'NHÂN DUYÊN TIỀN ĐÌNH', N'Chuyện phim xoay quanh nhân vật Chi-ho (Yoo Hae-jin) - nhà nghiên cứu bim bim với khả năng nếm
		vị xuất chúng, nhưng lại ngờ nghệch với mọi thứ xung quanh. Chi-ho là một người cực kỳ hướng nội,
		thích ở một mình và sống như một cái máy được lập trình sẵn mà không hề mắc lỗi dù chỉ một giây. 
		Trong lúc phải đi trả nợ thay cho người anh trai cờ bạc (Cha In-pyo), Chi-ho đã gặp gỡ “nhân viên 
		đòi nợ” Il-young - người phụ nữ hướng ngoại, luôn suy nghĩ tích cực về cuộc sống dù đang ở trong 
		hoàn cảnh khó khăn của một bà mẹ đơn thân. Khác biệt về tính cách lẫn ngoại hình khiến cả hai trở 
		thành “trái dấu hút nhau”. Sự “trái dấu” này đã đẩy đưa cuộc tình của họ đến vô vàn tình huống 
		“cười ra nước mắt” nhưng cũng không kém phần cảm xúc.','20230915',119,0,0,
		'ndtd.png','https://www.youtube.com/watch?v=zlPzyxdhQbI',50000,3)

INSERT INTO PHIM VALUES
(N'LIVE - #pháttrựctiếp', N'Bộ phim Việt đầu tiên trực diện nói về vấn đề bạo lực mạng xã hội.
		Câu chuyện xoay quanh hai người trẻ đầy tham vọng, bất chấp tất cả
		để có thể trở nên nổi tiếng trên mạng. Họ dùng đủ cách thức lẫn chiêu
		trò để đạt được mục đích của mình, cho đến khi chính bản thân họ lại 
		thành con mồi mới cho những kẻ trên mạng, những người sẵn sàng lao vào
		tấn công người khác chỉ vì “Không ưa con đó.”',
		'20230922',119,0,0,'phattructiep.png','https://www.youtube.com/watch?v=REgmCauEHDM',50000,4)

INSERT INTO PHIM VALUES
(N'THE NUN II', N'Là phần phim tiếp nối câu chuyện năm 2019 của The Nun, phim lấy bối cảnh nước Pháp năm 1956, 
		cùng cái chết bí ẩn của một linh mục, một giai thoại đáng sợ và ám ảnh sẽ mở ra tiếp tục xoay 
		quanh nhân vật chính - Sơ Irene. Liệu Sơ Irene có nhận ra, đây chính là hồn ma nữ tu Valak từng 
		có cuộc chiến “sống còn” với cô không lâu trước đây.',
		'20230915',91,0,0,'thenun2.png','https://www.youtube.com/watch?v=QF-oyCwaArU',50000,4)

INSERT INTO PHIM VALUES
(N'ĐẤT RỪNG PHƯƠNG NAM', N'Sau bao ngày chờ đợi, dự án điện ảnh gợi ký ức tuổi thơ của nhiều thế hệ người Việt chính thức 
		tung hình ảnh đầu tiên đầy cảm xúc. First look poster khắc họa hình ảnh đối lập: bé An đang ôm 
		chặt mẹ giữa một khung cảnh chạy giặc loạn lạc. Cùng chờ đợi và theo dõi thêm hành trình bé An đi
		tìm cha khắp nam kỳ lục tỉnh cùng các người bạn đồng hành nhé!',
		'20231020',110,0,0,'drpn.png','https://www.youtube.com/watch?v=hzyg3lvFPvk',50000,3)

INSERT INTO PHIM VALUES
(N'ARGYLLE SIÊU ĐIỆP VIÊN', N'Argylle là ai? Duy nhất 1 cách có thể tìm ra câu trả lời. ARGYLLE SIÊU ĐIỆP VIÊN | Dự Kiến Khởi Chiếu - Mùng 1 Tết 10.02.2024','20241002',
95,0,0,
'angylle.png','https://www.youtube.com/watch?v=7mgu9mNZ8Hk',50000,2)

INSERT INTO THELOAIP VALUES (N'Hành động', N'Phim có tính chất bạo lực và hành động mãn nhãn')
INSERT INTO THELOAIP VALUES (N'Giải trí', N'Phim có tính chất giải trí cao')
INSERT INTO THELOAIP VALUES (N'Kinh dị', N'Phim có tính chất kinh dị cao')

INSERT INTO TL_P VALUES (1,1)
INSERT INTO TL_P VALUES (1,3)
INSERT INTO TL_P VALUES (2,3)
INSERT INTO TL_P VALUES (3,1)
INSERT INTO TL_P VALUES (3,2)
INSERT INTO TL_P VALUES (4,3)
INSERT INTO TL_P VALUES (5,2)
INSERT INTO TL_P VALUES (6,2)
INSERT INTO TL_P VALUES (7,3)
INSERT INTO TL_P VALUES (7,1)
INSERT INTO TL_P VALUES (8,2)
INSERT INTO TL_P VALUES (8,1)

-- Lấy danh sách tất cả các bảng
SELECT table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'

--Truy xuất dữ liệu từ các bảng
SELECT* FROM LOAIKH
SELECT* FROM KHACHHANG
SELECT* FROM LAOINV
SELECT* FROM NHANVIEN
SELECT* FROM THELOAIP
SELECT* FROM GIOIHANTUOI
SELECT* FROM PHIM
SELECT* FROM TL_P
SELECT* FROM LOAIPC
SELECT* FROM LOAIGHE
SELECT* FROM PHONGCHIEU
SELECT* FROM GHECUAPC
SELECT* FROM XUATCHIEU
SELECT* FROM LICHCHIEU
SELECT* FROM BINHLUAN
SELECT* FROM YEUTHICH
SELECT* FROM VEPHIM
SELECT* FROM VE_GHE
SELECT* FROM HOADON
SELECT* FROM CHITIETHD

--Dữ liệu thử, xóa khi chạy chính
update phim
set LuotThich = 11234
where MaPhim = 2