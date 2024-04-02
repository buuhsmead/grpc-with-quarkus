package org.acme.probes;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import org.acme.GlobalConfig;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.HealthCheckResponseBuilder;
import org.eclipse.microprofile.health.Readiness;


// curl localhost:8080/q/health/ready

@Readiness
@ApplicationScoped
public class CustomeReadinessProbe implements HealthCheck {

    @Inject GlobalConfig globalConfig;


    @Override
    public HealthCheckResponse call() {

        HealthCheckResponseBuilder responseBuilder = HealthCheckResponse.named("Database connection health check");

        try {
            simulateDatabaseConnectionVerification();
            responseBuilder.up();
        } catch (IllegalStateException e) {
            // cannot access the database
            responseBuilder.down();
        }

        return responseBuilder.build();
    }

    private void simulateDatabaseConnectionVerification() {
        if (!globalConfig.getDatabaseUp()) {
            throw new IllegalStateException("Cannot contact database");
        }
    }

}
