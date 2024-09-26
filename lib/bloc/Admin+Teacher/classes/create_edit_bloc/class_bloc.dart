import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepository classRepository;
  final UserRepository userRepository;

  ClassBloc(this.classRepository, this.userRepository) : super(ClassInitial()) {
    on<LoadClasses>(_onLoadClasses);
    on<CreateClass>(_onCreateClass);
    on<EditClass>(_onEditClass);
    on<DeleteClass>(_onDeleteClass);
    on<FetchClassesEvent>(_onFetchClasses);
    on<RequestToJoinClassEvent>(_onRequestToJoinClass);
    on<FetchStudentsEvent>(_onFetchStudents);
    on<AddStudentEvent>(_onAddStudent);
    on<FetchUserEvent>(_onFetchUser);
    on<FetchGuardiansEvent>(_onFetchGuardians);
    on<FetchPendingRequestsEvent>(_onFetchPendingRequests); 
  }

Future<void> _onLoadClasses(LoadClasses event, Emitter<ClassState> emit) async {

  final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

  print('Loading classes...');
  emit(ClassLoading());
  try {
    final classes = await classRepository.fetchClasses(token);
    print('Classes loaded: ${classes.length}');
    emit(ClassLoaded(classes));
  } catch (e) {
    print('Error loading classes: $e');
    emit(ClassError(e.toString()));
  }
}


  Future<void> _onCreateClass(CreateClass event, Emitter<ClassState> emit) async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    try {
      await classRepository.createClass(event.newClass, token);
      add(LoadClasses());
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

Future<void> _onEditClass(EditClass event, Emitter<ClassState> emit) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('userToken');

  if (token == null) {
    throw Exception('Authentication token not found');
  }

  try {
    await classRepository.editClass(event.updatedClassData, token); // Call with Map
    add(LoadClasses());
  } catch (e) {
    emit(ClassError(e.toString()));
  }
}


  Future<void> _onDeleteClass(DeleteClass event, Emitter<ClassState> emit) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('userToken');

  if (token == null) {
    throw Exception('Authentication token not found');
  }
    try {
      await classRepository.deleteClass(event.classId, token);
      add(LoadClasses());
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  void _onFetchClasses(FetchClassesEvent event, Emitter<ClassState> emit) async {
    emit(ClassLoadingState());
    try {
      final token = await _getToken();

      if (token != null) {
        final classes = await classRepository.getClasses(token);
        emit(ClassLoadedState(classes));
      } else {
        emit(ClassErrorState("Token not found"));
      }
    } catch (e) {
      emit(ClassErrorState(e.toString()));
    }
  }

  void _onRequestToJoinClass(RequestToJoinClassEvent event, Emitter<ClassState> emit) async {
    try {
      final token = await _getToken();

      if (token != null) {
        await classRepository.requestToJoinClass(token, event.classCode);
        emit(JoinClassSuccessState());
      } else {
        emit(JoinClassErrorState("Token not found"));
      }
    } catch (e) {
      emit(JoinClassErrorState(e.toString()));
    }
  }

    void _onFetchStudents(FetchStudentsEvent event, Emitter<ClassState> emit) async {
    emit(StudentsLoadingState());
    try {
      final token = await _getToken();

      if (token != null) {
        final students = await classRepository.getStudentsByClassId(token, event.classId);
        emit(StudentsLoadedState(students));
      } else {
        emit(StudentsErrorState("Token not found"));
      }
    } catch (e) {
      emit(StudentsErrorState(e.toString()));
    }
  }

  void _onAddStudent(AddStudentEvent event, Emitter<ClassState> emit) async {
    try {
      final token = await _getToken();

      if (token != null) {
        await classRepository.addStudentToClass(token, event.classId, event.studentName, event.dob);
        emit(AddStudentSuccessState());
      } else {
        emit(AddStudentErrorState("Token not found"));
      }
    } catch (e) {
      emit(AddStudentErrorState(e.toString()));
    }
  }

  // Method to fetech user detail by id
// Method to fetch user detail by id
void _onFetchUser(FetchUserEvent event, Emitter<ClassState> emit) async {
  emit(UserLoadingState());
  try {
    final userRepository = UserRepository();  // Create an instance
    final user = await userRepository.getUserById(event.userId);  // Use the instance
    emit(UserLoadedState(user));
  } catch (e) {
    emit(UserErrorState(e.toString()));
  }
}

// Method to fetch guardians based on the list of IDs
void _onFetchGuardians(FetchGuardiansEvent event, Emitter<ClassState> emit) async {
  emit(GuardiansLoadingState());
  List<UserModel> guardiansList = [];

  if (event.guardianIds.isEmpty) {
    emit(GuardiansLoadedState(guardiansList));
    return;  // Exit early if there are no guardian IDs
  }

  final userRepository = UserRepository();  // Create an instance

  for (String guardianId in event.guardianIds) {
    try {
      UserModel guardian = await userRepository.getUserById(guardianId);  // Use the instance
      guardiansList.add(guardian);
      emit(GuardiansLoadedState(guardiansList));
    } catch (e) {
      print('Failed to fetch guardian with ID $guardianId: $e');
      emit(GuardiansErrorState('Failed to load some guardians.'));
    }
  }
}


  // Method to fetech pendiong requests
  void _onFetchPendingRequests(FetchPendingRequestsEvent event, Emitter<ClassState> emit) async {
   print("Fetching pending requests for classId: ${event.classId}, studentId: ${event.studentId}");
   emit(PendingRequestsLoadingState()); // Emit loading state
   try {
     final token = await _getToken();
     print("got token $token");
     if (token != null) {
        print("token not null");
       final pendingRequests = await classRepository.getPendingGuardianRequests(token, event.classId, event.studentId);
       print("Fetched pending requests: $pendingRequests");
       emit(PendingRequestsLoadedState(pendingRequests));
     } else {
       emit(PendingRequestsErrorState("Token not found"));
     }
   } catch (e) {
     emit(PendingRequestsErrorState(e.toString()));
   }
  }

}

