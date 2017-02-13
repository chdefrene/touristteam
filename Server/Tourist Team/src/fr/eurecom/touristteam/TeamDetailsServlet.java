package fr.eurecom.touristteam;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;

public class TeamDetailsServlet extends HttpServlet {
	
public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		if (request.getParameter("id") == null) {
			response.getWriter().println("ID cannot be empty!");
			return;
		}
		
		// Get the datastore
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		// Get the entity by key
		Entity team = null;
		try {
			team = datastore.get(KeyFactory.stringToKey(request.getParameter("id")));
		} catch (EntityNotFoundException e) {
			response.getWriter().println("Sorry, no team for the given key");
			return;
		}
		
		// Let's output the basic HTML headers
		PrintWriter out = response.getWriter();
		response.setContentType("text/html");
		out.println("<html><head><title>Teams list</title></head><body>");
		// Let's build the table headers
		out.println("<table style=\"border: 1px solid black; width: auto; text-align: center;\">"
			+ "<tr><td rowspan=6>");
		out.println("<td>Name: </td><td>" + team.getProperty("name") + "</td></tr>"
			+ "<tr><td>Current users: </td><td>" + team.getProperty("current_users") + "</td></tr>"
			+ "<tr><td>Max users: </td><td>" + team.getProperty("max_users") + "</td></tr>"
			+ "<tr><td>Age group: </td><td>" + team.getProperty("age_group") + "</td></tr>"
			+ "<tr><td>Mixed genders: </td><td>" + team.getProperty("mixed_genders") + "</td></tr>"
			+ "<tr><td>Common langauges: </td><td>" + team.getProperty("common_languages") + "</td></tr>");
		out.println("</table><a href=\"saveteam?id=" + request.getParameter("id")
			+ "\">Modify</a></body></html>");
		
	}

}
