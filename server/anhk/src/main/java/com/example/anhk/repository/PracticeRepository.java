package com.example.anhk.repository;

import com.example.anhk.model.entity.Practice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface PracticeRepository extends JpaRepository<Practice, UUID> {
}