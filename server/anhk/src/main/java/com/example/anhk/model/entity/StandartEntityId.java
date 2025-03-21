package com.example.anhk.model.entity;

import jakarta.persistence.*;
import lombok.Getter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.Objects;
import java.util.UUID;

@Getter
@MappedSuperclass
abstract class StandartEntityId extends AuditedEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(nullable = false)
    @JdbcTypeCode(SqlTypes.UUID)
    private UUID id;


    @javax.persistence.PrePersist
    public void prePersist() {
        generateUuid();
    }

    private void generateUuid() {
        if (this.id == null) {
            this.id = UUID.randomUUID();
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || !this.getClass().isAssignableFrom(o.getClass())) return false;
        StandartEntityId that = (StandartEntityId) o;
        return Objects.equals(id, that.getId());
    }

    @Override
    public int hashCode() {
        if (id != null) {
            return id.hashCode();
        }
        return super.hashCode();
    }

    public void setId(UUID id) {
        this.id = id;
    }
}