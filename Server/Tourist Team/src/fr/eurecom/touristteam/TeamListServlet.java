package fr.eurecom.touristteam;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.labs.repackaged.org.json.JSONArray;
import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

public class TeamListServlet extends HttpServlet {
	
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		// Take the list of contacts ordered by name
		Query query = new Query("Team").addSort("name", Query.SortDirection.ASCENDING);
		List<Entity> teams = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
		
		// Let's output the basic HTML headers
		PrintWriter out = response.getWriter();
		
		/** Different response type? */
		String responseType = request.getParameter("respType");
		if (responseType != null) {
			if (responseType.equals("json")) {
				// Set header to JSON output
				response.setContentType("application/json");
				out.println(getJSON(teams, request, response));
				return;
			}
		}
		
		response.setContentType("text/html");
		out.println("<html><head><title>Teams list</title></head></html>");
		if (teams.isEmpty()) {
			out.println("<h1>Your list is empty</h1>");
		} else {
			// Let's build the table headers
			out.println("<table style=\"border: 1px solid black; width: 100%; text-align: center;\">"+ "<tr><th>Team name</th><th>Current users</th><th>Max users</th><th>Age group</th><th>Mixed genders</th><th>Common languages</th></tr>");
			for (Entity team: teams) {
				out.println("<tr><td>" + team.getProperty("name") + "</td>"
						 	+ "<td>" + team.getProperty("current_users") + "</td>"
						 	+ "<td>" + team.getProperty("max_users") + "</td>"
						 	+ "<td>" + team.getProperty("age_group") + "</td>"
						 	+ "<td>" + team.getProperty("mixed_genders") + "</td>"
						 	+ "<td>" + team.getProperty("common_languages") + "</td>"
						 	+ "<td><a href=\"teamdetails?id="
						 	+ KeyFactory.keyToString(team.getKey())
						 	+ "\">details</a></td>"
						 	+ "</tr>");
			}
			out.println("</table>");
		}
		
		out.println(("</body></html>"));
		
	}

	private String getXML(List<Entity> contacts, HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		return null;
	}

	private String getJSON(List<Entity> teams, HttpServletRequest request, HttpServletResponse response) {
		// Create a JSON array that will contain all the entities converted in a JSON version
		JSONArray results = new JSONArray();
		for (Entity team: teams) {
			JSONObject teamJSON = new JSONObject();
			try {
				teamJSON.put("name", team.getProperty("name"));
				teamJSON.put("current_users", team.getProperty("current_users"));
				teamJSON.put("max_users", team.getProperty("max_users"));
				teamJSON.put("age_group", team.getProperty("age_group"));
				teamJSON.put("mixed_genders", team.getProperty("mixed_genders"));
				teamJSON.put("common_languages", team.getProperty("common_languages"));
			} catch (JSONException e) {
				e.printStackTrace();
			}
			results.put(teamJSON);
		}
		return results.toString();
	}

}
