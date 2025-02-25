﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Collections; // Sử dụng Lớp ArrayList để lưu kết quả
using System.Data.SqlClient;// Sử dụng các lớp tương tác CSDL
using CNPMNC_REPORT1.Models;

namespace CNPMNC_REPORT1.Areas.AdminArea.Controllers
{
    public class AdminController : Controller
    {

        // GET: AdminArea/Admin
        public ActionResult CustomerManager()
        {
            return View();
        }

        public ActionResult StaffManager()
        {
            return View();
        }

        public ActionResult Film()
        {
            SQLData data = new SQLData();
            ViewBag.DSGHTP = data.getData("SELECT * FROM GIOIHANTUOI");
            ViewBag.DSLPP = data.getData("SELECT * FROM THELOAIP");

            if (data.getData("SELECT * FROM PHIM") != null)
            {
                ViewBag.DSF = data.getData("SELECT * FROM PHIM");
            }

            return View();
        }
        [HttpPost]
        public ActionResult Film(int? MaP, string TenF, string MoTaF, string NgayCC, int? ThoiLuongP, string HinhAnhP, string TrailerP, string GHTP, int? GiaP, int? MaGHT, string status)
        {
            SQLData data = new SQLData();
            if (ModelState.IsValid)
            {
                if (status == "Add")
                {
                    if (TenF != null && MoTaF != null && NgayCC != null && ThoiLuongP != null && HinhAnhP != null && TrailerP != null && GHTP != null && GiaP != null)
                    {
                        int getMaGHT = data.getMaGHT(GHTP);
                        if (getMaGHT != 0)
                        {
                            bool isSaved = data.saveFilm(TenF, MoTaF, NgayCC, ThoiLuongP, HinhAnhP, TrailerP, GiaP, getMaGHT);
                            if (!isSaved)
                            {
                                ViewBag.ThongBaoLuu = "Lỗi lưu không thành công hoặc phim đã tồn tại!";
                                ViewBag.DSF = data.getData("SELECT * FROM PHIM");
                                ViewBag.DSGHTP = data.getData("SELECT * FROM GIOIHANTUOI");
                            }
                            else
                            {
                                ViewBag.DSF = data.getData("SELECT * FROM PHIM");
                                ViewBag.DSGHTP = data.getData("SELECT * FROM GIOIHANTUOI");
                            }
                        }
                        else
                        {
                            ViewBag.ThongBaoLuu = "Lỗi không tồn tại giới hạn tuổi!";
                            ViewBag.DSF = data.getData("SELECT * FROM PHIM");
                            ViewBag.DSGHTP = data.getData("SELECT * FROM GIOIHANTUOI");
                        }
                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSF = data.getData("SELECT * FROM PHIM");
                        ViewBag.DSGHTP = data.getData("SELECT * FROM GIOIHANTUOI");
                    }


                }
                else if (status == "Update")
                {
                    if (TenF != null && MoTaF != null && NgayCC != null && ThoiLuongP != null && HinhAnhP != null && TrailerP != null && MaGHT != null && GiaP != null)
                    {
                        bool isUpdate = data.updateFilm(MaP,TenF, MoTaF, NgayCC, ThoiLuongP, HinhAnhP, TrailerP, GiaP, MaGHT);
                        if (!isUpdate)
                        {
                            ViewBag.ThongBaoLuu = "Lỗi cập nhật không thành công!";
                            ViewBag.DSTLF = data.getData("SELECT * FROM PHIM");
                        }
                        else
                        {
                            ViewBag.DSTLF = data.getData("SELECT * FROM PHIM");
                        }
                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSTLF = data.getData("SELECT * FROM PHIM");
                    }
                }
                else ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
            }
            return View();
        }

        public ActionResult FilmType()
        {
            SQLData data = new SQLData();
            ViewBag.DSTLF = data.getData("SELECT * FROM THELOAIP");
            return View();
        }
        [HttpPost]
        public ActionResult FilmType(int? MaTL,string TenLF, string MoTaLF, string status)
        {
            SQLData data = new SQLData();
            if (ModelState.IsValid)
            {
                if (status == "Add")
                {
                    if (TenLF != null && MoTaLF != null)
                    {
                        ArrayList listfilmtype = data.getData($"SELECT * FROM THELOAIP WHERE TenTL=N'{TenLF}'");
                        if (listfilmtype.Count == 0)
                        {
                            bool isSaved = data.saveFilmType(TenLF, MoTaLF);
                            if (!isSaved)
                            {
                                @ViewBag.ThongBaoLuu = "Lỗi lưu không thành công!";
                            }
                            else ViewBag.DSTLF = data.getData("SELECT * FROM THELOAIP");
                        }
                        else
                        { 
                            ViewBag.ThongBaoLuu = "Đã tồn tại tên loại!";
                            ViewBag.DSTLF = data.getData("SELECT * FROM THELOAIP");
                        }
                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSTLF = data.getData("SELECT * FROM THELOAIP");
                    }


                }
                else if (status == "Update")
                {
                    if (TenLF != null && MoTaLF != null)
                    {
                        bool isUpdate = data.updateFilmTypeDetail(MaTL, TenLF, MoTaLF);
                        if (!isUpdate)
                        {
                            ViewBag.ThongBaoLuu = "Lỗi cập nhật không thành công!";
                            ViewBag.DSTLF = data.getData("SELECT * FROM THELOAIP");
                        }
                        else
                        {
                            ViewBag.DSTLF = data.getData("SELECT * FROM THELOAIP");
                        }
                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSTLF = data.getData("SELECT * FROM THELOAIP");
                    }
                }
                else ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
            }
            return View();
        }

        public ActionResult AgeLimit()
        {
            SQLData data = new SQLData();
            if (data.getData("SELECT * FROM GIOIHANTUOI")!=null)
            {
                ViewBag.DSGHT = data.getData("SELECT * FROM GIOIHANTUOI");
            }
            return View();
        }
        [HttpPost]
        public ActionResult AgeLimit(int? MaGHT,string TenGHT,string MoTaGHT, string status)
        {
            SQLData data = new SQLData();
            if (ModelState.IsValid)
            {
                if (status == "Add")
                {
                    if (TenGHT != null && MoTaGHT != null)
                    {
                        ArrayList listfilmtype = data.getData($"SELECT * FROM GIOIHANTUOI WHERE TenGHT=N'{TenGHT}'");
                        if (listfilmtype.Count == 0)
                        {
                            bool isSaved = data.saveAgeLimit(TenGHT, MoTaGHT);
                            if (!isSaved)
                            {
                                @ViewBag.ThongBaoLuu = "Lỗi lưu không thành công!";
                            }
                            else ViewBag.DSGHT = data.getData("SELECT * FROM GIOIHANTUOI");
                        }
                        else
                        {
                            ViewBag.ThongBaoLuu = "Đã tồn tại tên loại!";
                            ViewBag.DSGHT = data.getData("SELECT * FROM GIOIHANTUOI");
                        }
                        
                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSGHT = data.getData("SELECT * FROM GIOIHANTUOI");
                    }

                }
                else if (status == "Update")
                {
                    if (TenGHT != null && MoTaGHT != null)
                    {
                        bool isUpdate = data.updateAgeLimit(MaGHT, TenGHT, MoTaGHT);
                        if (!isUpdate)
                        {
                            ViewBag.ThongBaoLuu = "Lỗi cập nhật không thành công!";
                            ViewBag.DSGHT = data.getData("SELECT * FROM GIOIHANTUOI");
                        }
                        else
                        {
                            ViewBag.DSGHT = data.getData("SELECT * FROM GIOIHANTUOI");
                        }
                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSGHT = data.getData("SELECT * FROM GIOIHANTUOI");
                    }
                }
                else ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
            }
            return View();
        }

        public ActionResult Room()
        {
            SQLData data = new SQLData();
            ViewBag.ListLcuaPC = data.getData("SELECT * FROM LOAIPC");

            if (data.getData("SELECT * FROM PHONGCHIEU") != null)
            {
                ViewBag.DSPC = data.getData("SELECT * FROM PHONGCHIEU");
            }

            return View();
        }

        [HttpPost]
        public ActionResult Room(int? MaPC, string TenPC, int? SoLuongGT, int? SoLuongGV, string LoaiPC,int? MaLPC, string status)
        {
            SQLData data = new SQLData();

            if (ModelState.IsValid)
            {
                if (status == "Add")
                {
                    if (TenPC != null && SoLuongGT > 0 && SoLuongGV > 0 && LoaiPC != null)
                    {
                        int getMaLPC = data.getMaLoaiPC(LoaiPC);
                        if (getMaLPC != 0)
                        {
                            bool isSaved = data.saveRoom(TenPC, SoLuongGT, SoLuongGV, getMaLPC);
                            if (!isSaved)
                            {
                                ViewBag.ThongBaoLuu = "Lỗi lưu không thành công hoặc phòng chiếu đã tồn tại!";
                                ViewBag.DSPC = data.getData("SELECT * FROM PHONGCHIEU");
                                ViewBag.ListLcuaPC = data.getData("SELECT * FROM LOAIPC");
                            }
                            else
                            {
                                ViewBag.DSPC = data.getData("SELECT * FROM PHONGCHIEU");
                                ViewBag.ListLcuaPC = data.getData("SELECT * FROM LOAIPC");
                            }
                        }
                        else
                        {
                            ViewBag.ThongBaoLuu = "Lỗi không tồn tại loại phòng chiếu!";
                            ViewBag.DSPC = data.getData("SELECT * FROM PHONGCHIEU");
                            ViewBag.ListLcuaPC = data.getData("SELECT * FROM LOAIPC");
                        }
                    }

                }
                else if (status == "Update")
                {
                    if (TenPC != null && SoLuongGT > 0 && SoLuongGV > 0 && MaLPC != null)
                    {
                        bool isUpdate = data.updateRoom(MaPC, TenPC, SoLuongGT, SoLuongGV, MaLPC);
                        if (!isUpdate)
                        {
                            ViewBag.ThongBaoLuu = "Lỗi cập nhật không thành công!";
                            ViewBag.DSPC = data.getData("SELECT * FROM PHONGCHIEU");
                        }
                        else
                        {
                            ViewBag.DSPC = data.getData("SELECT * FROM PHONGCHIEU");
                        }
                    }
                }
                else
                {
                    ViewBag.DSPC = data.getData("SELECT * FROM PHONGCHIEU");
                    ViewBag.ListLcuaPC = data.getData("SELECT * FROM LOAIPC");
                }
            }

            return View();
        }



        public ActionResult RoomType()
        {
            SQLData data = new SQLData();
            if (data.getData("SELECT * FROM LOAIPC")!=null)
            {
                ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");
            }
            return View();
        }

        [HttpPost]
        public ActionResult RoomType(int? MaLPC, string TenLPC, string MoTaLPC, string status)
        {
            SQLData data = new SQLData();

            if (ModelState.IsValid)
            {
                if (TenLPC != null && MoTaLPC != null)
                {
                    if (status == "Add")
                    {
                        bool isSaved = data.saveRoomType(TenLPC, MoTaLPC);
                        if (!isSaved)
                        {
                            ViewBag.ThongBaoLuu = "Lỗi lưu không thành công!";
                            ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");
                        }
                        else ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");
                    }
                    else if (status == "Update")
                    {
                        if (MaLPC != null)
                        {
                            bool isUpdate = data.updateRoomTypeDetail(MaLPC, TenLPC, MoTaLPC);
                            if (!isUpdate)
                            {
                                ViewBag.ThongBaoLuu = "Lỗi cập nhật không thành công!";
                                ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");
                            }
                            else ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");
                        }
                        else
                        {
                            ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");
                            ViewBag.ThongBaoLuu = "Lỗi cập nhật không thành công!";
                        }
                    }
                    else ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");

                } else ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");
            }
            else ViewBag.DSLPC = data.getData("SELECT * FROM LOAIPC");

            return View();
        }

        public ActionResult TheLoaiVaPhim()
        {
            SQLData data = new SQLData();
            if (data.getData("SELECT * FROM TL_P") != null)
            {
                ViewBag.DSTLVP = data.getData("SELECT * FROM TL_P");
            }
            return View();
        }
        [HttpPost]
        public ActionResult TheLoaiVaPhim(int? MaTLP, int? MaPhim, int? MaTL, string status)
        {
            SQLData data = new SQLData();

            if (ModelState.IsValid)
            {
                if (status == "Add")
                {
                    if (MaPhim != null && MaTL != null)
                    {
                        ArrayList listfilmtype = data.getData($"SELECT * FROM TL_P WHERE MaPhim={MaPhim} AND MaTL={MaTL}");
                        if (listfilmtype.Count == 0)
                        {
                            bool isSaved = data.saveTheLoaiVaPhim(MaPhim, MaTL);
                            if (!isSaved)
                            {
                                ViewBag.ThongBaoLuu = "Lỗi lưu không thành công!";
                            }
                            else ViewBag.DSTLVP = data.getData("SELECT * FROM TL_P");
                        }
                        else
                        {
                            ViewBag.ThongBaoLuu = "Đã tồn tại!";
                            ViewBag.DSTLVP = data.getData("SELECT * FROM TL_P");
                        }

                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSTLVP = data.getData("SELECT * FROM TL_P");
                    }

                }
                else if (status == "Update")
                {
                    if (MaPhim != null && MaTL != null)
                    {
                        bool isUpdate = data.updateTheLoaiVaPhim(MaTLP, MaPhim, MaTL);
                        if (!isUpdate)
                        {
                            ViewBag.ThongBaoLuu = "Lỗi cập nhật không thành công!";
                            ViewBag.DSTLVP = data.getData("SELECT * FROM TL_P");
                        }
                        else
                        {
                            ViewBag.DSTLVP = data.getData("SELECT * FROM TL_P");
                        }
                    }
                    else
                    {
                        ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
                        ViewBag.DSTLVP = data.getData("SELECT * FROM TL_P");
                    }
                }
                else ViewBag.ThongBaoLuu = "Lỗi không tồn tại!";
            }

            return View();
        }

    }
}