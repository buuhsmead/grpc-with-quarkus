package org.acme;


import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/database")
public class DatabaseResource {

    @Inject
    GlobalConfig globalConfig;

    // JUST FOR DEMO USING a GET
    @Path("/enable")
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String enableDatabase() {
        globalConfig.setDatabaseUp(true);
        return "DATABASE ENABLED - Readines Probe - " + globalConfig.getDatabaseUp();
    }

    // JUST FOR DEMO USING a GET
    @Path("/disable")
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String disableDatabase() {
        globalConfig.setDatabaseUp(false);
        return "DATABASE DISABLED - Readines Probe - " + globalConfig.getDatabaseUp();
    }

}
