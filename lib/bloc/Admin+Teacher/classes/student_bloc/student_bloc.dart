import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/student_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository studentRepository;
  final UserRepository userRepository;

  StudentBloc(this.studentRepository, this.userRepository) : super(StudentInitialState()) {
    on<FetchClassesEvent>(_onFetchClasses);
    on<RequestToJoinClassEvent>(_onRequestToJoinClass);
    on<FetchStudentsEvent>(_onFetchStudents);
    on<AddStudentEvent>(_onAddStudent);
    on<FetchUserEvent>(_onFetchUser);
    on<FetchGuardiansEvent>(_onFetchGuardians);
    on<FetchPendingRequestsEvent>(_onFetchPendingRequests); 
  }

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  void _onFetchClasses(FetchClassesEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoadingState());
    try {
      final token = await _getToken();

      if (token != null) {
        final classes = await studentRepository.getClasses(token);
        emit(StudentLoadedState(classes));
      } else {
        emit(StudentErrorState("Token not found"));
      }
    } catch (e) {
      emit(StudentErrorState(e.toString()));
    }
  }

  void _onRequestToJoinClass(RequestToJoinClassEvent event, Emitter<StudentState> emit) async {
    try {
      final token = await _getToken();

      if (token != null) {
        await studentRepository.requestToJoinClass(token, event.classCode);
        emit(JoinClassSuccessState());
      } else {
        emit(JoinClassErrorState("Token not found"));
      }
    } catch (e) {
      emit(JoinClassErrorState(e.toString()));
    }
  }

  void _onFetchStudents(FetchStudentsEvent event, Emitter<StudentState> emit) async {
    emit(StudentsLoadingState());
    try {
      final token = await _getToken();

      if (token != null) {
        final students = await studentRepository.getStudentsByClassId(token, event.classId);
        emit(StudentsLoadedState(students));
      } else {
        emit(StudentsErrorState("Token not found"));
      }
    } catch (e) {
      emit(StudentsErrorState(e.toString()));
    }
  }

  void _onAddStudent(AddStudentEvent event, Emitter<StudentState> emit) async {
    try {
      final token = await _getToken();

      if (token != null) {
        await studentRepository.addStudentToClass(token, event.classId, event.studentName, event.dob);
        emit(AddStudentSuccessState());
      } else {
        emit(AddStudentErrorState("Token not found"));
      }
    } catch (e) {
      emit(AddStudentErrorState(e.toString()));
    }
  }

  // Method to fetech user detail by id
  void _onFetchUser(FetchUserEvent event, Emitter<StudentState> emit) async {
    emit(UserLoadingState());
    try {
      final user = await userRepository.getUserById(event.userId);
      emit(UserLoadedState(user));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  // Method to fetch guardians based on the list of IDs
  void _onFetchGuardians(FetchGuardiansEvent event, Emitter<StudentState> emit) async {
    emit(GuardiansLoadingState());
    List<UserModel> guardiansList = [];

    if(event.guardianIds.isEmpty) {
      emit(GuardiansLoadedState(guardiansList));
    }

    for (String guardianId in event.guardianIds) {
      try {
        UserModel guardian = await userRepository.getUserById(guardianId);
        guardiansList.add(guardian);
        emit(GuardiansLoadedState(guardiansList));
      } catch (e) {
        print('Failed to fetch guardian with ID $guardianId: $e');
        emit(GuardiansErrorState('Failed to load some guardians.'));
      }
    }

    
  }

  // Method to fetech pendiong requests
  void _onFetchPendingRequests(FetchPendingRequestsEvent event, Emitter<StudentState> emit) async {
   print("Fetching pending requests for classId: ${event.classId}, studentId: ${event.studentId}");
   emit(PendingRequestsLoadingState()); // Emit loading state
   try {
     final token = await _getToken();
     print("got token $token");
     if (token != null) {
        print("token not null");
       final pendingRequests = await studentRepository.getPendingGuardianRequests(token, event.classId, event.studentId);
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
