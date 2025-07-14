package Services;

import DAOs.CheckinDAO;
import Models.Checkin;
import java.util.List;

public class CheckinService {
    private final CheckinDAO checkinDAO = new CheckinDAO();

    public List<Checkin> getCheckinHistoryByMemberId(int memberId) {
        return checkinDAO.getCheckinHistoryByMemberId(memberId);
    }

    public List<Checkin> getAllCheckins() {
        return checkinDAO.getAllCheckins();
    }
}
