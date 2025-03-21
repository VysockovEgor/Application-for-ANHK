package com.example.anhk.model.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "question_option")
public class QuestionOption extends StandartEntityId {

    @Column(name = "question_text", nullable = false, length = Integer.MAX_VALUE)
    private String questionText;


    @ColumnDefault("true")
    @Column(name = "is_active")
    private Boolean isActive;


}