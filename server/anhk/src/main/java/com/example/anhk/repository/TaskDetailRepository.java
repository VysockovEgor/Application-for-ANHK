package com.example.anhk.repository;

import com.example.anhk.model.entity.TaskDetail;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface TaskDetailRepository extends JpaRepository<TaskDetail, UUID> {
}