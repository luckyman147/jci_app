import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';
const options: swaggerJsdoc.Options = {
  swaggerDefinition: {
    openapi: '3.1.0',
    
    
    info: {
      title: 'Node.js Swagger API',
      version: '1.0.0',
      description: '1 page  Swagger documentation',
    },
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      }
    },
  
    security: [{
      bearerAuth: []
    }],
    servers: [
      {
        url: 'http://localhost:8080',
      },  {
        url: 'http://localhost:8080',
      },
    ],
  },
  apis: ['./src/routes/activity/activityRoute.ts',"./src/routes/Board/*.ts","./src/routes/superAdminRoute.ts"], // Path to the API routes files
};const options2: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.1.0',
    info: {
      title: 'Node.js Swagger API',
      version: '2.0.0',
      description: 'Second Page  Swagger documentation',
    },
    servers: [
      {
        url: 'http://localhost:8080',
      },
    ],
  },
  apis: ['./src/routes/activity/activityRoute.ts',"./src/routes/Board/*.ts","./src/routes/superAdminRoute.ts"], // Path to the API routes files
};
// Swagger configuration for the first page
const swaggerUiOptions1 = {
  customSiteTitle: 'Swagger Page 1',
  customCss: '.swagger-ui .topbar { display: none }', // Optional: hide topbar
};

// Swagger configuration for the second page
const swaggerUiOptions2 = {
  customSiteTitle: 'Swagger Page 2',
  customCss: '.swagger-ui .topbar { display: none }', // Optional: hide topbar
};

const specs = swaggerJsdoc(options);
const specs2 = swaggerJsdoc(options2);

export { specs, swaggerUi,specs2,swaggerUiOptions1,swaggerUiOptions2 };

