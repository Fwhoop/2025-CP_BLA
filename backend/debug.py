# debug.py - Test each import to find the issue

print("Testing imports one by one...")

try:
    from fastapi import FastAPI, Depends
    print("✓ FastAPI imports OK")
except Exception as e:
    print("✗ FastAPI import failed:", e)

try:
    from fastapi.middleware.cors import CORSMiddleware
    print("✓ CORS import OK")
except Exception as e:
    print("✗ CORS import failed:", e)

try:
    from app.db import Base, engine
    print("✓ app.db import OK")
except Exception as e:
    print("✗ app.db import failed:", e)

try:
    from app.deps import get_current_user
    print("✓ app.deps import OK")
except Exception as e:
    print("✗ app.deps import failed:", e)

try:
    from app.schemas import UserRead
    print("✓ app.schemas import OK")
except Exception as e:
    print("✗ app.schemas import failed:", e)

try:
    from app.models import User
    print("✓ app.models import OK")
except Exception as e:
    print("✗ app.models import failed:", e)

try:
    from app.routers import auth
    print("✓ app.routers.auth import OK")
except Exception as e:
    print("✗ app.routers.auth import failed:", e)

try:
    from app.routers import users
    print("✓ app.routers.users import OK")
except Exception as e:
    print("✗ app.routers.users import failed:", e)

try:
    from app.routers import barangays
    print("✓ app.routers.barangays import OK")
except Exception as e:
    print("✗ app.routers.barangays import failed:", e)

try:
    from app.routers import cases
    print("✓ app.routers.cases import OK")
except Exception as e:
    print("✗ app.routers.cases import failed:", e)

try:
    from app.routers import chat
    print("✓ app.routers.chat import OK")
except Exception as e:
    print("✗ app.routers.chat import failed:", e)

print("\nNow testing the main module...")

try:
    import app.main
    print("✓ app.main module loads")
    print("Available attributes:", [attr for attr in dir(app.main) if not attr.startswith('_')])
except Exception as e:
    print("✗ app.main module failed to load:", e)
    import traceback
    traceback.print_exc()

try:
    from app.main import app
    print("✓ Successfully imported app from app.main")
    print("App type:", type(app))
except Exception as e:
    print("✗ Failed to import app from app.main:", e)
    import traceback
    traceback.print_exc()