package com.team3.market.dao;

import java.util.List;
import java.util.Map;

public interface AdminDAO {

	List<Map<String, Object>> selectPostReportList();

	List<Map<String, Object>> selectUserReportList();

}
