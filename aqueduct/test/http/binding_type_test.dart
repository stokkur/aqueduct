import 'dart:async';
import 'dart:io';
import 'package:aqueduct/aqueduct.dart';
import "package:test/test.dart";

void main() {
  group("Non-list success", () {
    test("Can bind String to query, header, path", () {
      final controller = StandardSet();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });

    test("Can bind parseable types to query, header, path", () {
      final controller = ParseSet();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });

    test("Can bind bool to query", () {
      final controller = BoolBind();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });

    test("Can bind HTTPSerializable to body", () {
      final controller = BodyBind();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });
  });

  group("List success", () {
    test("Can bind String to query, header, path", () {
      final controller = StandardListSet();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });

    test("Can bind parseable types to query, header, path", () {
      final controller = ParseListSet();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });

    test("Can bind bool to query", () {
      final controller = BoolListBind();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });

    test("Can bind HTTPSerializable to body", () {
      final controller = BodyListBind();
      controller.restore(controller.recycledState);
      controller.didAddToChannel();
      // Just expecting that we don't throw
      expect(true, true);
    });
  });

  group("Error cases", () {
    test("Cannot bind dynamic", () {
      final controller = ErrorDynamic();
      try {
        controller.restore(controller.recycledState);
        controller.didAddToChannel();
      } on StateError catch (e) {
        expect(e.toString(),
            "Bad state: Invalid binding 'x' on 'ErrorDynamic.get1': 'dynamic' may not be bound to Header.");
      }
    });

    test("Cannot bind invalid type to default implementation", () {
      final controller = ErrorDefault();
      try {
        controller.restore(controller.recycledState);
        controller.didAddToChannel();
      } on StateError catch (e) {
        expect(e.toString(),
            "Bad state: Invalid binding 'x' on 'ErrorDefault.get1': 'HttpHeaders' may not be bound to Header.");
      }
    });

    test("Cannot bind bool to default implementation", () {
      final controller = ErrorDefaultBool();
      try {
        controller.restore(controller.recycledState);
        controller.didAddToChannel();
      } on StateError catch (e) {
        expect(e.toString(),
            "Bad state: Invalid binding 'x' on 'ErrorDefaultBool.get1': 'bool' may not be bound to Header.");
      }
    });

    test("Cannot bind whacky type to body", () {
      final controller = ErrorBody();
      try {
        controller.restore(controller.recycledState);
        controller.didAddToChannel();
      } on StateError catch (e) {
        expect(e.toString(),
            "Bad state: Invalid binding 'x' on 'ErrorBody.get1': 'HttpHeaders' may not be bound to Body.");
      }
    });

    test("Cannot bind default type to body", () {
      final controller = ErrorDefaultBody();
      try {
        controller.restore(controller.recycledState);
        controller.didAddToChannel();
      } on StateError catch (e) {
        expect(e.toString(),
            "Bad state: Invalid binding 'x' on 'ErrorDefaultBody.get1': 'String' may not be bound to Body.");
      }
    });
  });
}

class StandardSet extends ResourceController {
  @Operation.get('id')
  Future<Response> get1(@Bind.header("foo") String a, @Bind.path("id") String b,
      @Bind.query("c") String c) async {
    return Response.ok(null);
  }
}

class ParseSet extends ResourceController {
  @Operation.get('id')
  Future<Response> get1(@Bind.header("foo") int a, @Bind.path("id") DateTime b,
      @Bind.query("c") num c) async {
    return Response.ok(null);
  }
}

class BoolBind extends ResourceController {
  @Operation.get('id')
  // ignore: avoid_positional_boolean_parameters
  Future<Response> get1(@Bind.query("foo") bool a) async {
    return Response.ok(null);
  }
}

class BodyBind extends ResourceController {
  @Operation.post()
  Future<Response> get1(@Bind.body() Serial a) async {
    return Response.ok(null);
  }
}

class StandardListSet extends ResourceController {
  @Operation.get('id')
  Future<Response> get1(@Bind.header("foo") List<String> a,
      @Bind.path("id") List<String> b, @Bind.query("c") List<String> c) async {
    return Response.ok(null);
  }
}

class ParseListSet extends ResourceController {
  @Operation.get('id')
  Future<Response> get1(@Bind.header("foo") List<int> a,
      @Bind.path("id") List<DateTime> b, @Bind.query("c") List<num> c) async {
    return Response.ok(null);
  }
}

class BoolListBind extends ResourceController {
  @Operation.get('id')
  Future<Response> get1(@Bind.query("foo") List<bool> a) async {
    return Response.ok(null);
  }
}

class BodyListBind extends ResourceController {
  @Operation.post()
  Future<Response> get1(@Bind.body() List<Serial> a) async {
    return Response.ok(null);
  }
}

class ErrorDynamic extends ResourceController {
  @Operation.get()
  Future<Response> get1(@Bind.header("foo") dynamic x) async {
    return Response.ok(null);
  }
}

class ErrorDefault extends ResourceController {
  @Operation.get()
  Future<Response> get1(@Bind.header("foo") HttpHeaders x) async {
    return Response.ok(null);
  }
}

class ErrorDefaultBool extends ResourceController {
  @Operation.get()
  // ignore: avoid_positional_boolean_parameters
  Future<Response> get1(@Bind.header("foo") bool x) async {
    return Response.ok(null);
  }
}

class ErrorBody extends ResourceController {
  @Operation.get()
  Future<Response> get1(@Bind.body() HttpHeaders x) async {
    return Response.ok(null);
  }
}

class ErrorDefaultBody extends ResourceController {
  @Operation.get()
  Future<Response> get1(@Bind.body() String x) async {
    return Response.ok(null);
  }
}

class Serial extends HTTPSerializable {
  @override
  void readFromMap(Map<String, dynamic> requestBody) {}

  @override
  Map<String, dynamic> asMap() {
    return {};
  }
}
