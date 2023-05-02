-- 14. Liệt kê những sinh viên nam của khoa Anh văn và khoa tin học, gồm các thông tin: Mã sinh viên, Họ tên sinh viên, tên khoa, Phái.
SELECT s.MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", k.TenKhoa, s.Phai FROM dmsv s
JOIN DMKhoa k ON k.MaKhoa = s.MaKhoa WHERE s.Phai = "Nam" AND (s.MaKhoa = "AV" OR s.MaKhoa = "TH");

-- 15. Liệt kê những sinh viên nữ, tên có chứa chữ N
SELECT * FROM dmsv WHERE CONCAT(HoSV, " ", TenSV) LIKE "%N%";
 
-- 16. Danh sách sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02, gồm các thông tin: Họ sinh viên, Tên sinh viên, Nơi sinh, Ngày sinh.
SELECT HoSV, TenSV, NoiSinh, NgaySinh FROM dmsv WHERE NoiSinh = "Hà Nội" AND MONTH(NgaySinh) = 2;

-- 17. Cho biết những sinh viên có tuổi lớn hơn 20, thông tin gồm: Họ tên sinh viên, Tuổi,Học bổng.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", YEAR(NOW()) - YEAR(NgaySinh) AS Tuổi , HocBong FROM dmsv WHERE YEAR(NOW()) - YEAR(NgaySinh) > 20 ;

-- 18. Danh sách những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên, Tuổi, Tên khoa.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", YEAR(NOW()) - YEAR(NgaySinh) AS Tuổi , k.TenKhoa FROM dmsv s
JOIN DMKhoa k ON k.MaKhoa = s.MaKhoa
WHERE YEAR(NOW()) - YEAR(NgaySinh) BETWEEN 20 AND 25 ;

-- 19. Danh sách sinh viên sinh vào mùa xuân năm 1990, gồm các thông tin: Họ tên sinh viên,Phái, Ngày sinh.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", Phai, NgaySinh FROM dmsv WHERE YEAR(NgaySinh) = 1990 AND (MONTH(NgaySinh) BETWEEN 1 AND 3);

-- 20. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Phái, Mã khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị của field học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”
SELECT MaSV, Phai, MaKhoa, IF (HocBong > 500000, "Học Bổng Cao", "Học Bổng Trung Bình") AS "Mức học bổng" FROM dmsv;

-- 21. Cho biết tổng số sinh viên của toàn trường
SELECT COUNT(MaSV) AS "Tổng số SV" FROM dmsv;

-- 22. Cho biết tổng sinh viên và tổng sinh viên nữ.
SELECT TongSV as "Tổng số SV", TongSVN as "Tổng số SV Nữ" FROM (
	SELECT @stt := @stt + 1 as STT , COUNT(MaSV) AS TongSV FROM (select @stt:=0) stt, dmsv s
	) AS tongSV JOIN (
		SELECT @stt := @stt + 1 as STT, COUNT(MaSV) AS TongSVN FROM (select @stt:=0) stt, dmsv s WHERE Phai = "Nữ"
		) AS svn ON tongSV.STT = svn.STT;
        
-- 23. Cho biết tổng số sinh viên của từng khoa.
SELECT k.TenKhoa, COUNT(MaSV) AS "Số SV" FROM dmsv s
JOIN DMKhoa k ON k.MaKhoa = s.MaKhoa 
GROUP BY s.MaKhoa;

-- 24. Cho biết số lượng sinh viên học từng môn.
SELECT m.TenMH, COUNT(MaSV) AS "Số SV" FROM KetQua kq
JOIN DMMH m ON m.MaMH = kq.MaMH 
GROUP BY m.TenMH;

-- 25. Cho biết số lượng môn học mà sinh viên đã học(tức tổng số môn học có trong bảng kq)
SELECT COUNT(MaMH) AS "Tổng số môn học" FROM DMMH WHERE MaMH IN (SELECT MaMH FROM KetQua GROUP BY MaMH);

-- 26. Cho biết tổng số học bổng của mỗi khoa.
SELECT k.TenKhoa, SUM(HocBong) FROM dmsv s 
JOIN DMKhoa k ON k.MaKhoa = s.MaKhoa
GROUP BY k.TenKhoa;

-- 27. Cho biết học bổng cao nhất của mỗi khoa.
SELECT k.TenKhoa, MAX(HocBong) FROM dmsv s 
JOIN DMKhoa k ON k.MaKhoa = s.MaKhoa
GROUP BY k.TenKhoa;

-- 28. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa.
SELECT dmkhoa.TenKhoa,
COUNT(dmsv.Phai = 'Nữ' OR NULL) AS TongSoSinhVienNu,
COUNT(dmsv.Phai = 'Nam' OR NULL) AS TongSoSinhVienNam
FROM dmkhoa JOIN dmsv ON dmkhoa.MaKhoa = dmsv.MaKhoa
GROUP BY dmkhoa.TenKhoa;

-- 29. Cho biết số lượng sinh viên theo từng độ tuổi.
SELECT (YEAR(NOW()) - YEAR(NgaySinh)) AS Tuổi, COUNT(YEAR(NOW()) - YEAR(NgaySinh) IN (SELECT (YEAR(NOW()) - YEAR(NgaySinh)) AS Tuổi FROM dmsv GROUP BY Tuổi)) AS "Số lượng SV theo tuổi" FROM dmsv GROUP BY YEAR(NOW()) - YEAR(NgaySinh);

-- 30. Cho biết những năm sinh nào có 2 sinh viên đang theo học tại trường.
SELECT YEAR(NgaySinh) AS NămSinh, COUNT(YEAR(NOW()) - YEAR(NgaySinh) IN (SELECT (YEAR(NOW()) - YEAR(NgaySinh)) AS Tuổi FROM dmsv GROUP BY Tuổi)) AS CountSV FROM dmsv GROUP BY YEAR(NgaySinh) HAVING CountSV = 2 ;

-- 31. Cho biết những nơi nào có hơn 2 sinh viên đang theo học tại trường.
SELECT NoiSinh, COUNT(NoiSinh IN (SELECT NoiSinh FROM dmsv GROUP BY NoiSinh)) AS "Số lượng SV" FROM dmsv GROUP BY NoiSinh;

-- 32. Cho biết những môn nào có trên 3 sinh viên dự thi.
SELECT TenMH, COUNT(KetQua.MaMH) SoSV FROM KetQua JOIN DMMH ON KetQua.MaMH = DMMH.MaMH WHERE LanThi = 1 GROUP BY KetQua.MaMH HAVING SoSV > 3;

-- 33. Cho biết những sinh viên thi lại trên 2 lần.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV" FROM dmsv JOIN KetQua ON dmsv.MaSV = KetQua.MaSV WHERE KetQua.LanThi = 2 GROUP BY CONCAT(HoSV, " ", TenSV);

-- 34. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", Phai, AVG(Diem) FROM dmsv JOIN KetQua ON Ketqua.MaSV = dmsv.MaSV WHERE Phai = "Nam" AND LanThi = 1 GROUP BY CONCAT(HoSV, " ", TenSV), Phai HAVING AVG(Diem) > 7;

-- 35. Cho biết danh sách các sinh viên rớt trên 2 môn ở lần thi 1.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV" FROM dmsv JOIN KetQua ON dmsv.MaSV = KetQua.MaSV WHERE LanThi = 2 GROUP BY CONCAT(HoSV, " ", TenSV);

-- 36. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
SELECT TenKhoa, COUNT(MaSV) FROM dmsv JOIN DMKhoa ON dmsv.MaKhoa = DMKhoa.MaKhoa WHERE Phai = "Nam" GROUP BY TenKhoa HAVING COUNT(MaSV) > 2;

-- 37. Cho biết những khoa có 2 sinh đạt học bổng từ 200.000 đến 300.000.
SELECT TenKhoa, COUNT(TenKhoa) AS SoLuongSV FROM (SELECT TenKhoa, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", HocBong FROM dmsv JOIN DMKhoa ON dmsv.MaKhoa = DMKhoa.MaKhoa WHERE HocBong BETWEEN 100000 AND 300000) A GROUP BY TenKhoa HAVING COUNT(TenKhoa) = 2;

-- 38. Cho biết số lượng sinh viên đậu và số lượng sinh viên rớt của từng môn trong lần thi 1.
SELECT DMMH.TenMH, COUNT(Ketqua.LanThi = 2 OR NULL) Trượt, (SELECT COUNT(MaSV) FROM dmsv) - COUNT(Ketqua.LanThi = 2 OR NULL) Đỗ FROM KetQua JOIN DMMH WHERE DMMH.MaMH = KetQua.MaMH GROUP BY TenMH;

-- 39. Cho biết sinh viên nào có học bổng cao nhất.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", HocBong FROM dmsv WHERE HocBong = (SELECT MAX(HocBong) FROM dmsv);

-- 40. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", Diem FROM KetQua JOIN dmsv ON dmsv.MaSV = KetQua.MaSV WHERE Diem = (SELECT MAX(Diem) FROM KetQua WHERE MaMH = 01 AND LanThi = 1);

-- 41. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", YEAR(NOW()) - YEAR(NgaySinh) AS Tuổi FROM DMKhoa JOIN dmsv ON dmsv.MaKhoa = DMKhoa.MaKhoa WHERE TenKhoa = 'Anh Văn' AND YEAR(NOW()) - YEAR(NgaySinh) = (SELECT MAX(Tuổi) Tuổi FROM (SELECT TenKhoa, TenSV, YEAR(NOW()) - YEAR(NgaySinh) AS Tuổi FROM DMKhoa JOIN dmsv ON dmsv.MaKhoa = DMKhoa.MaKhoa WHERE TenKhoa = 'Anh Văn') `max`);

-- 42. Cho biết khoa nào có đông sinh viên nhất.
SELECT TenKhoa, COUNT(MaSV) SoSV FROM dmsv JOIN DMKhoa ON dmsv.MaKhoa = DMKhoa.MaKhoa GROUP BY DMKhoa.MaKhoa HAVING SoSV = (SELECT MAX(SoSV) FROM (SELECT MaKhoa, COUNT(MaSV) SoSV FROM dmsv GROUP BY MaKhoa) SoLuongSV);

-- 43. Cho biết khoa nào có đông nữ nhất.
SELECT TenKhoa, COUNT(TenSV) SoSVN FROM dmsv JOIN DMKhoa ON DMKhoa.MaKhoa = dmsv.MaKhoa WHERE Phai = "Nữ" GROUP BY TenKhoa HAVING SoSVN = (SELECT MAX(SoSVN) FROM (SELECT MaKhoa, COUNT(TenSV) SoSVN FROM dmsv WHERE Phai = "Nữ" GROUP BY MaKhoa) ds);

-- 44. Cho biết môn nào có nhiều sinh viên rớt lần 1 nhiều nhất.
SELECT TenMH, COUNT(MaSV) SoSV FROM KetQua JOIN DMMH ON DMMH.MaMH = KetQua.MaMH WHERE LanThi = 2 GROUP BY TenMH HAVING SoSV = (SELECT MAX(SoSV) FROM (SELECT MaMH, COUNT(MaSV) SoSV FROM KetQua WHERE LanThi = 2 GROUP BY MaMH) ds);

-- 45. Cho biết sinh viên không học khoa anh văn có điểm thi môn văn lớn hơn điểm thi văn của sinh viên học khoa anh văn.
SELECT KetQua.MaSV, TenSV, MaKhoa, Diem FROM KetQua JOIN dmsv ON dmsv.MaSV = KetQua.MaSV WHERE NOT KetQua.MaSV IN (SELECT MaSV FROM dmsv WHERE NOT MaKhoa = "AV") AND MaMH = (SELECT MaMH FROM DMMH WHERE TenMH = "Văn Phạm") AND Diem > (SELECT Diem FROM KetQua JOIN dmsv ON dmsv.MaSV = KetQua.MaSV WHERE KetQua.MaSV IN (SELECT MaSV FROM dmsv WHERE MaKhoa = "AV") AND MaMH = (SELECT MaMH FROM DMMH WHERE TenMH = "Văn Phạm"));

-- 46. Cho biết sinh viên có nơi sinh cùng với Hải.
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", NoiSinh FROM dmsv WHERE NoiSinh = (SELECT NoiSinh FROM dmsv WHERE TenSv = "Hải") AND NOT TenSV = "Hải";

-- 47. Cho biết những sinh viên nào có học bổng lớn hơn tất cả học bổng của sinh viên thuộc khoa anh văn
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", HocBong FROM dmsv WHERE HocBong > (SELECT SUM(HocBong) FROM dmsv WHERE MaKhoa = "AV");

-- 48. Cho biết những sinh viên có học bổng lớn hơn bất kỳ học bổng của sinh viên học khóa anh văn
SELECT CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", HocBong FROM dmsv WHERE HocBong > (SELECT MAX(HocBong) FROM dmsv WHERE MaKhoa = "AV");

-- 49. Cho biết sinh viên nào có điểm thi môn cơ sở dữ liệu lần 2 lớn hơn tất cả điểm thi lần 1 môn cơ sở dữ liệu của những sinh viên khác.
SELECT MaSV, Diem FROM KetQua WHERE LanThi = 2 AND MaMH = "01" AND Diem > (SELECT MAX(Diem) FROM KetQua WHERE LanThi = 1 AND MaMH = "01");

-- 50. Cho biết những sinh viên đạt điểm cao nhất trong từng môn.
SELECT MaMH, MAX(Diem) FROM KetQua GROUP BY MaMH;

SELECT mh.TenMH, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", MAX(k1.Diem) FROM KetQua k1 
JOIN (SELECT MaMH, MAX(Diem) MaxDiem FROM KetQua GROUP BY MaMH) k2 ON k1.MaMH = k2.MaMH
JOIN DMMH mh ON mh.MaMH = k1.MaMH
JOIN dmsv sv ON sv.MaSV = k1.MaSV
WHERE k1.Diem = k2.MaxDiem GROUP BY k1.MaMH, k1.MaSV; 

-- 51.  Cho biết những khoa không có sinh viên học.
SELECT MaKhoa FROM dmsv;
SELECT MaKhoa, TenKhoa FROM DMKhoa WHERE MaKhoa NOT IN (SELECT MaKhoa FROM dmsv);

-- 52. Cho biết sinh viên chưa thi môn cơ sở dữ liệu.
SELECT MaMH FROM DMMH WHERE TenMH = "Cơ sở dữ liệu";
SELECT MaSV FROM KetQua WHERE MaMH = (SELECT MaMH FROM DMMH WHERE TenMH = "Cơ sở dữ liệu");
SELECT MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV" FROM dmsv WHERE MaSV NOT IN (SELECT MaSV FROM KetQua WHERE MaMH = (SELECT MaMH FROM DMMH WHERE TenMH = "Cơ sở dữ liệu"));

-- 53. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2.
SELECT MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV" FROM dmsv WHERE MaSV NOT IN (SELECT MaSV FROM KetQua WHERE LanThi = 1) AND MaSV IN (SELECT MaSV FROM KetQua WHERE LanThi = 2); 

-- 54. Cho biết môn nào không có sinh viên khoa anh văn học.
SELECT MaMH FROM KetQua WHERE MaSV IN (SELECT MaSV FROM dmsv WHERE MaKhoa = (SELECT MaKhoa FROM DMKhoa WHERE TenKhoa = "Anh Văn")) GROUP BY MaMH;

SELECT MaMH, TenMH FROM DMMH WHERE MaMH NOT IN (SELECT MaMH FROM KetQua WHERE MaSV IN (SELECT MaSV FROM dmsv WHERE MaKhoa = (SELECT MaKhoa FROM DMKhoa WHERE TenKhoa = "Anh Văn")) GROUP BY MaMH);

-- 55. Cho biết những sinh viên khoa anh văn chưa học môn văn phạm.
SELECT MaSV FROM dmsv WHERE MaKhoa = (SELECT MaKhoa FROM DMKhoa WHERE TenKhoa = "Anh Văn");
SELECT MaMH FROM DMMH WHERE TenMH = "văn phạm";
SELECT MaSV FROM KetQua WHERE MaSV IN (SELECT MaSV FROM dmsv WHERE MaKhoa = (SELECT MaKhoa FROM DMKhoa WHERE TenKhoa = "Anh Văn")) AND MaMH = (SELECT MaMH FROM DMMH WHERE TenMH = "văn phạm");
SELECT MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV" FROM dmsv WHERE MaKhoa = (SELECT MaKhoa FROM DMKhoa WHERE TenKhoa = "Anh Văn") AND MaSV NOT IN (SELECT MaSV FROM KetQua WHERE MaSV IN (SELECT MaSV FROM dmsv WHERE MaKhoa = (SELECT MaKhoa FROM DMKhoa WHERE TenKhoa = "Anh Văn")) AND MaMH = (SELECT MaMH FROM DMMH WHERE TenMH = "văn phạm"));

-- 56. Cho biết những sinh viên không rớt môn nào.
SELECT MaSV FROM KetQua WHERE LanThi = 2; -- ĐỘI THI LẠI
SELECT MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV" FROM dmsv WHERE MaSV NOT IN (SELECT MaSV FROM KetQua WHERE LanThi = 2);

-- 57. Cho biết những sinh viên học khoa anh văn có học bổng và những sinh viên chưa bao giờ rớt.
SELECT dmsv.MaSV, CONCAT(dmsv.HoSV, ' ', dmsv.TenSV) AS HoTenSV
FROM dmsv
JOIN KetQua ON dmsv.MaSV = KetQua.MaSV
WHERE dmsv.MaSV NOT IN (SELECT MaSV FROM KetQua WHERE LanThi = 2)
OR (dmsv.HocBong <> 0 
AND dmsv.MaKhoa = (SELECT MaKhoa FROM DMKhoa WHERE TenKhoa = 'Anh Văn')) GROUP BY MaSV;

-- 58. Cho biết khoa nào có đông sinh viên nhận học bổng nhất và khoa nào khoa nào có ít sinh viên nhận học bổng nhất.
SELECT MaKhoa, COUNT(HocBong <> 0 OR NULL) SLHocBong FROM dmsv GROUP BY MaKhoa;
SELECT MAX(HocBong) FROM (SELECT MaKhoa, COUNT(HocBong <> 0 OR NULL) HocBong FROM dmsv GROUP BY MaKhoa) DS;
SELECT MIN(HocBong) FROM (SELECT MaKhoa, COUNT(HocBong <> 0 OR NULL) HocBong FROM dmsv GROUP BY MaKhoa) DS;
SELECT TenKhoa, SLHocBong FROM (SELECT MaKhoa, COUNT(HocBong <> 0 OR NULL) SLHocBong FROM dmsv GROUP BY MaKhoa) ds JOIN DMKhoa ON DMKhoa.MaKhoa = ds.MaKhoa WHERE SLHocBong = (SELECT MAX(HocBong) FROM (SELECT MaKhoa, COUNT(HocBong <> 0 OR NULL) HocBong FROM dmsv GROUP BY MaKhoa) DS) OR SLHocBong = (SELECT MIN(HocBong) FROM (SELECT MaKhoa, COUNT(HocBong <> 0 OR NULL) HocBong FROM dmsv GROUP BY MaKhoa) DS);

-- 59. Cho biết 3 sinh viên có học nhiều môn nhất.
SELECT MaSV, MaMH FROM KetQua GROUP BY MaSV, MaMH;
SELECT ds.MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", COUNT(MaMH) "Số môn học" FROM (SELECT MaSV, MaMH FROM KetQua GROUP BY MaSV, MaMH) DS JOIN dmsv ON dmsv.MaSV = ds.MaSV GROUP BY MaSV ORDER BY COUNT(MaMH) DESC LIMIT 3;

-- 60. Cho biết những môn được tất cả các sinh viên theo học.
SELECT MaSV, MaMH, COUNT(MaSV) FROM KetQua GROUP BY MaMH, MaSV;
SELECT MaMH, COUNT(MaSV) FROM (SELECT MaSV, MaMH FROM KetQua GROUP BY MaMH, MaSV) DS GROUP BY MaMH;
SELECT COUNT(MaSV) FROM dmsv;
SELECT MaMH, SLSV FROM (SELECT MaMH, COUNT(MaSV) SLSV FROM (SELECT MaSV, MaMH FROM KetQua GROUP BY MaMH, MaSV) DS GROUP BY MaMH) ds WHERE SLSV = (SELECT COUNT(MaSV) FROM dmsv);

-- 61. Cho biết những sinh viên học những môn giống sinh viên có mã số A02 học.
SELECT MaSV, MaMH FROM KetQua WHERE MaSV = "A02" GROUP BY MaMH;
SELECT DISTINCT KetQua.MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", MaMH FROM KetQua JOIN dmsv ON dmsv.MaSV = KetQua.MaSV WHERE MaMH IN (SELECT MaMH FROM KetQua WHERE MaSV = "A02" GROUP BY MaMH) AND KetQua.MaSV <> "A02";

-- 62. Cho biết những sinh viên học những môn bằng đúng những môn mà sinh viên A02 học.
SELECT MaSV, MaMH FROM KetQua WHERE MaSV = "A02" GROUP BY MaMH;
SELECT DISTINCT KetQua.MaSV, CONCAT(HoSV, " ", TenSV) AS "Họ tên SV", MaMH FROM KetQua JOIN dmsv ON dmsv.MaSV = KetQua.MaSV WHERE NOT EXISTS (SELECT MaMH FROM KetQua WHERE MaSV = "A02" GROUP BY MaMH) AND KetQua.MaSV <> "A02";

