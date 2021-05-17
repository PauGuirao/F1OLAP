package Model;

public class ConstructorResults {
    private int constructorResultId;
    private int raceId;
    private int constructorId;
    private float points;
    private String status;

    public int getConstructorResultId() {
        return constructorResultId;
    }

    public void setConstructorResultId(int constructorResultId) {
        this.constructorResultId = constructorResultId;
    }

    public int getRaceId() {
        return raceId;
    }

    public void setRaceId(int raceId) {
        this.raceId = raceId;
    }

    public int getConstructorId() {
        return constructorId;
    }

    public void setConstructorId(int constructorId) {
        this.constructorId = constructorId;
    }

    public float getPoints() {
        return points;
    }

    public void setPoints(float points) {
        this.points = points;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
