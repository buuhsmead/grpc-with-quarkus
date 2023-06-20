package org.acme;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.config.ConfigProvider;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/database")
public class DatabaseResource {
    
    @Inject GlobalConfig globalConfig;

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
