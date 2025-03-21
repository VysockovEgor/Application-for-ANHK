package com.example.anhk.model.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "anketa")
public class Anketa extends StandartEntityId {
    @Column(name = "difficulty_rating", nullable = false)
    private Long difficultyRating;

    @Column(name = "satisfaction_rating", nullable = false)
    private Long satisfactionRating;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToMany
    @JoinTable(name = "anketa_question_link",
    joinColumns = @JoinColumn(name = "anketa_id"),
    inverseJoinColumns = @JoinColumn(name = "question_id"))
    private Set<QuestionOption> questions;

}