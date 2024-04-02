package org.acme;



import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@ApplicationScoped
public class GlobalConfig {

    @ConfigProperty(name = "database.up", defaultValue = "true")
    boolean databaseUp;


    public boolean getDatabaseUp() {
        return databaseUp;
    }

    public void setDatabaseUp(boolean setUpOrDown) {
        databaseUp = setUpOrDown;
    }


}
