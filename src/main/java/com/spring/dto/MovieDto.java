package com.spring.dto;

public class MovieDto {

    private Long id;          // movies.id
    private String title;     // movies.title
    private Integer runtimeMin; // movies.runtime_min AS runtimeMin
    private String rating;    // movies.rating
    private String description; // movies.description

    public MovieDto() {}

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getRuntimeMin() {
        return runtimeMin;
    }
    public void setRuntimeMin(Integer runtimeMin) {
        this.runtimeMin = runtimeMin;
    }

    public String getRating() {
        return rating;
    }
    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "MovieDto{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", runtimeMin=" + runtimeMin +
                ", rating='" + rating + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
