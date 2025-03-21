package com.example.anhk.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "practice")
public class Practice extends StandartEntityId {

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "description", nullable = false)
    private String description;

    @Column(name = "average_difficulty_rating", nullable = false)
    private Long averageDifficultyRating;

    @Column(name = "average_satisfaction_rating", nullable = false)
    private Long averageSatisfactionRating;

}