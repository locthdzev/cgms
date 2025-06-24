package Utilities;

import io.minio.*;
import io.minio.http.Method;

import java.io.InputStream;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

public class MinioUtil {
    private static MinioClient minioClient;
    private static String bucketName;
    private static String publicEndpoint;

    static {
        try {
            Properties properties = new Properties();
            InputStream inputStream = MinioUtil.class.getClassLoader().getResourceAsStream("app.properties");
            properties.load(inputStream);

            String endpoint = properties.getProperty("minio.endpoint");
            publicEndpoint = properties.getProperty("minio.public.endpoint");
            String accessKey = properties.getProperty("minio.access.key");
            String secretKey = properties.getProperty("minio.secret.key");
            bucketName = properties.getProperty("minio.bucket.name");

            minioClient = MinioClient.builder()
                    .endpoint("http://" + endpoint)
                    .credentials(accessKey, secretKey)
                    .build();

            // Check if bucket exists, if not create it
            boolean found = minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build());
            if (!found) {
                minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucketName).build());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Upload a file to MinIO storage
     * 
     * @param inputStream The input stream of the file
     * @param fileName    Original file name
     * @param contentType Content type of the file (e.g., "image/jpeg")
     * @return The URL of the uploaded file
     */
    public static String uploadFile(InputStream inputStream, String fileName, String contentType) throws Exception {
        return uploadFile(inputStream, fileName, contentType, null);
    }

    /**
     * Upload a file to MinIO storage in a specific folder
     * 
     * @param inputStream The input stream of the file
     * @param fileName    Original file name
     * @param contentType Content type of the file (e.g., "image/jpeg")
     * @param folder      Folder name to store the file in (e.g., "Products")
     * @return The URL of the uploaded file
     */
    public static String uploadFile(InputStream inputStream, String fileName, String contentType, String folder)
            throws Exception {
        // Generate a unique file name to avoid collisions
        String extension = fileName.substring(fileName.lastIndexOf("."));
        String uniqueFileName = UUID.randomUUID().toString() + extension;

        // Add folder prefix if specified
        String objectName = (folder != null && !folder.isEmpty()) ? folder + "/" + uniqueFileName : uniqueFileName;

        // Upload the file to MinIO
        minioClient.putObject(
                PutObjectArgs.builder()
                        .bucket(bucketName)
                        .object(objectName)
                        .stream(inputStream, -1, 10485760) // 10MB
                        .contentType(contentType)
                        .build());

        // Tạo URL theo định dạng API của MinIO
        String encodedPrefix = URLEncoder.encode(objectName, StandardCharsets.UTF_8.toString());
        return "https://" + publicEndpoint + "/api/v1/buckets/" + bucketName + "/objects/download?preview=true&prefix="
                + encodedPrefix;
    }

    /**
     * Generate a presigned URL for downloading a file
     * 
     * @param objectName The name of the object in MinIO
     * @param expiryTime Expiry time in seconds
     * @return Presigned URL for the object
     */
    public static String getPresignedUrl(String objectName, int expiryTime) throws Exception {
        return minioClient.getPresignedObjectUrl(
                GetPresignedObjectUrlArgs.builder()
                        .method(Method.GET)
                        .bucket(bucketName)
                        .object(objectName)
                        .expiry(expiryTime, TimeUnit.SECONDS)
                        .build());
    }

    /**
     * Delete a file from MinIO storage
     * 
     * @param objectName The name of the object in MinIO
     */
    public static void deleteFile(String objectName) throws Exception {
        minioClient.removeObject(
                RemoveObjectArgs.builder()
                        .bucket(bucketName)
                        .object(objectName)
                        .build());
    }

    /**
     * Extract object name from a full URL
     * 
     * @param url Full URL of the object
     * @return Object name
     */
    public static String getObjectNameFromUrl(String url) {
        if (url == null)
            return null;

        // Xử lý URL API mới
        if (url.contains("/api/v1/buckets/")) {
            try {
                String prefix = url.substring(url.indexOf("prefix=") + 7);
                // Decode URL encoded prefix
                return URLDecoder.decode(prefix, StandardCharsets.UTF_8.toString());
            } catch (Exception e) {
                e.printStackTrace();
                // Fallback to old method
                String[] parts = url.split("/");
                return parts[parts.length - 1];
            }
        }

        // Xử lý URL cũ
        String[] parts = url.split("/");
        if (parts.length >= 2) {
            return parts[parts.length - 2] + "/" + parts[parts.length - 1];
        }
        return parts[parts.length - 1];
    }
}