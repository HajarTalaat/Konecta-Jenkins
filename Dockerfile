# Use official Nginx image
FROM nginx:latest

# Remove default Nginx page and add custom index.html
RUN rm -rf /usr/share/nginx/html/*
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
