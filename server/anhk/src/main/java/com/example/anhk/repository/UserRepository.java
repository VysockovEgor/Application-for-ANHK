package com.example.anhk.repository;

import com.example.anhk.config.Constants;
import com.example.anhk.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import java.util.List;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {

    boolean existsByPasswordHash(String password);

    boolean existsByLogin(String username);

    List<User> findByLogin(@NotNull @Pattern(regexp = Constants.LOGIN_REGEX) @Size(min = 1, max = 100) String login);
}