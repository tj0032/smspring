package edu.sm.app.repository;

import edu.sm.app.dto.Burger;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface BurgerRepository {
    List<Burger> selectAll();
}
