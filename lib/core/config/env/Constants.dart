                                                      import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants{
static String MANAGE_MEETINGS=dotenv.env['MANAGE_MEETINGS']??"".trim();
static String MANAGE_EVENTS=dotenv.env['MANAGE_EVENTS']??"".trim();
static String MANAGE_TRAININGS=dotenv.env['MANAGE_TRAININGS']??"".trim();
static String MANAGE_POINTS=dotenv.env['MANAGE_POINTS']??"".trim();
static String MANAGE_MEMBERS=dotenv.env['MANAGE_MEMBERS']??"".trim();
static String MANAGE_OBJECTIFS =dotenv.env['MANAGE_OBJ']??"".trim();
static String MANAGE_TEAMS =dotenv.env['MANAGE_TEAM']??"".trim();
static String MANAGE_PROJECTS =dotenv.env['MANAGE_OBJ']??"".trim();
static String API_KEY = dotenv.env["API_KEY"] ?? "";
}