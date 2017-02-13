package fr.eurecom.touristteam;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.KeyFactory;

public class SaveTeamServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("text/html");

		// Let's output the basic HTML headers
		PrintWriter out = response.getWriter();
		out.println("<html><head><title>Modify a team</title></head><body>");

		// Get the datastore
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

		// Get the entity by key
		Entity team = null;
		String name = "", currentUsers = "", maxUsers = "", ageGroup = "", mixedGenders = "", commonLanguages = "";
		try {
			team = datastore.get(KeyFactory.stringToKey(request.getParameter("id")));
			name = (team.getProperty("name") != null) ? (String) team.getProperty("name") : "";
			currentUsers = (team.getProperty("current_users") != null) ? (String) team.getProperty("current_users") : "";
			maxUsers = (team.getProperty("max_users") != null) ? (String) team.getProperty("max_users") : "";
			ageGroup = (team.getProperty("age_group") != null) ? (String) team.getProperty("age_group") : "";
			ageGroup = (team.getProperty("mixed_genders") != null) ? (String) team.getProperty("mixed_genders") : "";
			ageGroup = (team.getProperty("common_languages") != null) ? (String) team.getProperty("common_languages") : "";
		} catch (EntityNotFoundException e) {
			response.getWriter().println("<p>Creating a new team</p>");
		} catch (NullPointerException e) {
			// id paramenter not present in the URL
			response.getWriter().println("<p>Creating a new team</p>");
		}
		out.println("<form action=\"saveteam\" method=\"post\" name=\"team\">");

		// Let's build the form
		out.println("<label>Name: </label><input name=\"name\" value=\"" + name + "\"/><br/>"
				+ "<label>Current users: </label><input name=\"current_users\" value=\"" + currentUsers + "\"/><br/>"
				+ "<label>Max users: </label><input name=\"max_users\" value=\"" + maxUsers + "\"/><br/>"
				+ "<label>Age group: </label><input name=\"age_group\" value=\"" + ageGroup + "\"/><br/>"
				+ "<label>Mixed genders: </label><input name=\"mixed_genders\" value=\"" + mixedGenders + "\"/><br/>"
				+ "<label>Common languages: </label><input name=\"common_languages\" value=\"" + commonLanguages + "\"/><br/>");
		out.println("<br/><input type=\"submit\" value=\"Continue\"/></form></body></html>");
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// Information from the request
		String teamName = request.getParameter("name");
		String currentUsers = request.getParameter("current_users");
		String maxUsers = request.getParameter("max_users");
		String ageGroup = request.getParameter("age_group");
		String mixedGenders = request.getParameter("mixed_genders");
		String commonLanguages = request.getParameter("common_languages");

		// Datastore reference
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

		// Generate or retrieve the key
		Entity team;
		team = new Entity("Team", teamName);
		team.setProperty("name", teamName);
		team.setProperty("current_users", currentUsers);
		team.setProperty("max_users", maxUsers);
		team.setProperty("age_group", ageGroup);
		team.setProperty("mixed_genders", mixedGenders);
		team.setProperty("common_languages", commonLanguages);

		// Save in the datastore
		datastore.put(team);

		response.getWriter().println("Team " + teamName + " saved with key " + KeyFactory.keyToString(team.getKey()) + "."
										+"<html><br><td><a href='/'>Return to home</a></td>");
	}

}
