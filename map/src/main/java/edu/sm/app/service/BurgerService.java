package edu.sm.app.service;

import edu.sm.app.dto.Burger;
import edu.sm.app.repository.BurgerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BurgerService {
    private final BurgerRepository repo;
    public List<Burger> getAll() { return repo.selectAll(); }
}
