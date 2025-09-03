package eud.sm.app.repository;

import eud.sm.app.dto.Marker;
import eud.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
@Mapper
public interface MarkerRepository extends SmRepository<Marker, Integer> {
    List<Marker> findByLoc(int loc);
}