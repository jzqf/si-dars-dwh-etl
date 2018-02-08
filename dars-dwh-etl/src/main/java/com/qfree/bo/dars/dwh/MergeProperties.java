package com.qfree.bo.dars.dwh;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class MergeProperties {

	//private static final Logger logger = LoggerFactory.getLogger(MergeProperties.class);

	private static final String SHOW_VERSION_ARG = "-v";
	private static final String UPDATE_DEFAULTS_ARG = "defaults";

	public static void main(String[] args) {

		/*
		 * Determine if this application is being run to generate a new version
		 * of the file kettle.properties for release to a customer, or for
		 * local development.
		 * 
		 * If this application is being run without arguments, it will generate 
		 * a new version of the file:
		 * 
		 *   $KETTLE_HOME/.kettle/kettle.properties
		 * 
		 * by merging both of the files, separately:
		 * 
		 *   $DWH_HOME/conf/dwh-qfree.properties
		 *   $DWH_HOME/conf/dwh.properties
		 * 
		 * with the existing copy of 
		 * 
		 *   $KETTLE_HOME/.kettle/kettle.properties .
		 *   
		 * During development, $KETTLE_HOME/.kettle/kettle.properties resolves
		 * to:
		 * 
		 *    /opt/qfree/dwh_etl/development/.kettle/kettle.properties
		 * 
		 * but for the customer (where the KETTLE_HOME environemnt variable is
		 * defined differently), this resolves to:
		 * 
		 *    /opt/qfree/dwh_etl/pdi_config/.kettle/kettle.properties
		 * 
		 * During *development*, this will merge the *development* versions of
		 * dwh-qfree.properties & dwh.properties with the *development* version 
		 * of kettle.properties. However, if the *customer* performs this same 
		 * action, it will merge the customer's copies of dwh-qfree.properties & 
		 * dwh.properties with the customer's one and only copy of 
		 * kettle.properties.
		 * 
		 * 
		 * This application also accepts a single optional argument:
		 * 
		 *   defaults
		 * 
		 * The "defaults" argument is only used during development. If it is
		 * passed to this application, then this application will merge a 
		 * *different* set of dwh-qfree.properties & dwh.properties files with a
		 * *different* kettle.properties file. In particular, it will generate 
		 * a new version of the file:
		 * 
		 *   $KETTLE_HOME_DEFAULTS/.kettle/kettle.properties
		 * 
		 * by merging the files:
		 * 
		 *   $DWH_HOME/templates/dwh-qfree.properties
		 *   $DWH_HOME/templates/dwh.properties
		 * 
		 * with the existing copy of 
		 * 
		 *   $KETTLE_HOME_DEFAULTS/.kettle/kettle.properties .
		 * 
		 * During development (the only time that this option will be used), 
		 * this updates the copy of kettle.properties that will be packaged and
		 * sent to the customer with the copies of dwh-qfree.properties & 
		 * dwh.properties that contain default values that also will be packaged
		 * and sent to the customer. These copies of dwh-qfree.properties & 
		 * dwh.properties should not contain any hostnames, passwords, e-mail
		 * addresses, etc., that are not appropriate for a customer's 
		 * environment.
		 */

		boolean showVersion = (args.length > 0) && SHOW_VERSION_ARG.equals(args[0]);
		if (showVersion) {


			Properties configProperties = new Properties();
			InputStream input = null;

			printVersion: try {

				String filename = "config.properties";
				input = MergeProperties.class.getClassLoader().getResourceAsStream(filename);
				if (input == null) {
					System.out.println("Sorry, unable to find file: " + filename);
					break printVersion;
				}

				configProperties.load(input); // Load config.properties file from class path

				// Get the version and print it out
				String appVersion = configProperties.getProperty("app.version");
				System.out.println(appVersion);

			} catch (IOException ex) {
				ex.printStackTrace();
			} finally {
				if (input != null) {
					try {
						input.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}

		} else {

			//	System.out.println("args.length = " + args.length);
			boolean mergeDefaultProperties = (args.length > 0) && UPDATE_DEFAULTS_ARG.equals(args[0]);
			//	System.out.println("mergeDefaultProperties = " + mergeDefaultProperties);

			Map<String, String> env = System.getenv();
			//for (String envName : env.keySet()) {
			//	System.out.format("%s=%s%n", envName, env.get(envName));
			//}

			String kettleHome = null;
			if (mergeDefaultProperties) {
				kettleHome = env.get("KETTLE_HOME_DEFAULTS");
				if (kettleHome == null) {
					throw new RuntimeException("KETTLE_HOME_DEFAULTS environment variable does not exist!");
				}
			} else {
				kettleHome = env.get("KETTLE_HOME");
				if (kettleHome == null) {
					throw new RuntimeException("KETTLE_HOME environment variable does not exist!");
				}
			}
			//System.out.println(String.format("kettleHome = %s", kettleHome));
			//logger.info("kettleHome = {}", kettleHome);

			String dwhHome = env.get("DWH_HOME");
			if (dwhHome == null) {
				throw new RuntimeException("DWH_HOME environment variable does not exist!");
			}
			//System.out.println(String.format("dwhHome = %s", dwhHome));
			//logger.info("dwhHome = {}", dwhHome);

			Properties kettleProperties = new Properties();
			Properties qfreeProperties = new Properties();
			Properties customerProperties = new Properties();

			InputStream in;
			OutputStream out;
			try {

				/*
				 * Read in the kettle.properties file that will be updated.
				 */
				in = new FileInputStream(kettleHome + "/.kettle/kettle.properties");
				kettleProperties.load(in);
				in.close();
				//	System.out.println("\nkettle.properties:");
				//	for (String key : kettleProperties.stringPropertyNames()) {
				//		System.out.println(String.format("%s=%s", key, kettleProperties.getProperty(key, "")));
				//	}

				/*
				 * Read in the Q-Free installation-specific properties file.
				 */
				if (mergeDefaultProperties) {
					in = new FileInputStream(dwhHome + "/templates/dwh-qfree.properties");
				} else {
					in = new FileInputStream(dwhHome + "/conf/dwh-qfree.properties");
				}
				qfreeProperties.load(in);
				in.close();
				//	System.out.println("\ndwh-qfree.properties:");
				//	for (String key : qfreeProperties.stringPropertyNames()) {
				//		System.out.println(String.format("%s=%s", key, qfreeProperties.getProperty(key, "")));
				//	}

				/*
				 * Read in the customer's installation-specific (local) properties 
				 * file.
				 */
				if (mergeDefaultProperties) {
					in = new FileInputStream(dwhHome + "/templates/dwh.properties");
				} else {
					in = new FileInputStream(dwhHome + "/conf/dwh.properties");
				}
				customerProperties.load(in);
				in.close();
				//	System.out.println("\ndwh.properties:");
				//	for (String key : customerProperties.stringPropertyNames()) {
				//		System.out.println(String.format("%s=%s", key, customerProperties.getProperty(key, "")));
				//	}

				/*
				 * Merge the installation-specific Q-Free properties into 
				 * kettle.properties.
				 */
				for (String key : qfreeProperties.stringPropertyNames()) {
					kettleProperties.setProperty(key, qfreeProperties.getProperty(key, ""));
				}

				/*
				 * Merge the installation-specific customer properties into 
				 * kettle.properties.
				 */
				for (String key : customerProperties.stringPropertyNames()) {
					kettleProperties.setProperty(key, customerProperties.getProperty(key, ""));
				}

				//System.out.println("kettle.properties after merging:");
				/*
				 * Print the properties sorted by key, which will be *much* easier to digest.
				 */
				List<String> keys = new ArrayList<>();
				for (String key : kettleProperties.stringPropertyNames()) {
					keys.add(key);
				}
				Collections.sort(keys);
				for (String key : keys) { // kettleProperties.stringPropertyNames()) {
					System.out.println(String.format("%s=%s", key, kettleProperties.getProperty(key, "")));
				}

				//String now = new SimpleDateFormat("dd-MM-yyyy_HH:mm:ss").format(new Date());
				String now = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

				/*
				 * Write the updated/merged kettle.properties file to the file
				 * system, overwriting the current file that was loaded above.
				 * 
				 * However, we create a backup of kettle.properties first, in case
				 * updating the current file runs into problems for some reason.
				 */
				Path kettlePropertiesPath = Paths.get(kettleHome + "/.kettle/kettle.properties");
				Path kettlePropertiesBackupPath = Paths.get(kettleHome + "/.kettle/kettle.properties." + now);
				Files.copy(kettlePropertiesPath, kettlePropertiesBackupPath, StandardCopyOption.REPLACE_EXISTING);
				out = new FileOutputStream(kettleHome + "/.kettle/kettle.properties");
				kettleProperties.store(out, null);
				out.close();
				//Files.deleteIfExists(kettlePropertiesBackupPath);   Don't delete the backup file

			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}

		}
	}

}
