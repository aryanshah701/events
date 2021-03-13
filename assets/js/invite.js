// Design for this file was inspired by Tuck notes 0309 voting.js
import $ from "jquery";

// Update num invites and no responses on the screen
function update_invites(resp, status, _xhr) {
  const event = resp.data.event;
  const email = resp.data.user_email;

  // Update the DOM
  $("#invites").text(event.num_invites);
  $("#no-response").text(event.num_no_response);
  $("#yes").text(event.num_yes);
  $("#maybe").text(event.num_maybe);
  $("#no").text(event.num_no);

  // See if the invite already exists
  $(".invite-in-list").each((i, invite) => {
    let invite_email = $(invite).data("invite-email");
    if (invite_email == email) {
      $(invite).find(".response").text(response_to_string(resp.data.response));
      return;
    }
  });
}

function response_to_string(resp) {
  switch (resp) {
    case "yes":
      return "Attending";
    case "no":
      return "Not Attending";
    case "maybe":
      return "Maybe";
    default:
      return "No Response";
  }
}

// Show the error on the screen as a flash
function show_error(_xhr, status, error) {
  $("#flash-container").append(
    "<div class='alert alert-danger' role='alert'>" +
      "Oops something went wrong. Make sure you aren't inviting someone you already have.</div>"
  );
}

// Make the AJAX req for adding an invite
function addInvite(event_id) {
  // Get the invite email
  const user_email = $("#invite-email").val();
  $("#invite-email").val("");

  const response = "no resp";
  const invite = { invite: { user_email, event_id, response } };

  $.ajax("/api/invites", {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: JSON.stringify(invite),
    headers: {
      "x-auth": window.userToken,
    },
    success: update_invites,
    error: show_error,
  });
}

// Handle response update
function update_response(response) {
  // Get the event id
  const event_id = $("#response-yes").data("event-id");
  const invite = { invite: { event_id, response } };

  $.ajax("/api/invites", {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: JSON.stringify(invite),
    headers: {
      "x-auth": window.userToken,
    },
    success: update_invites,
    error: show_error,
  });
}

// Add all the click events
function setup() {
  console.log("From invite module");

  // Grab the event id
  let event_id = $("#invite").data("event-id");

  // Add click listener on the event button
  $("#invite").click(() => {
    console.log("Clicked");
    addInvite(event_id);
  });

  // Add click listener on the yes button
  $("#response-yes").click(() => {
    console.log("Clicked yes");
    update_response("yes");
  });

  // Add click listener on the no button
  $("#response-no").click(() => {
    console.log("Clicked no");
    update_response("no");
  });

  // Add click listener on the maybe button
  $("#response-maybe").click(() => {
    console.log("Clicked maybe");
    update_response("maybe");
  });
}

$(setup);
